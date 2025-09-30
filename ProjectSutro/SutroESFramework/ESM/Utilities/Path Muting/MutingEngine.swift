//
//  MutingEngine.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/7/23.
//

import Foundation
import OSLog

/// Defines constants and  functions for working with path muting at the Endpoint Security level
///
/// Principle is ``applyDefaultMuteSet(client:)`` which takes an ES client and applies the default
/// mute set.
public class MutingEngine {
    
    /// Applies the default mute set to an Endpoint Security client.
    public static func applyDefaultMuteSet(client: OpaquePointer?) {
        _processMuteSet(
            MuteSet.default,
            client: client,
            eventAction: es_mute_path_events,
            globalAction: es_mute_path
        )
    }
    
    /// Unmutes all paths and events defined in the default mute set.
    public static func unmuteDefaultMuteSet(client: OpaquePointer?) {
        _processMuteSet(
            MuteSet.default,
            client: client,
            eventAction: es_unmute_path_events,
            globalAction: es_unmute_path
        )
    }
    
    private static func _processMuteSet(
        _ muteSet: MuteSet,
        client: OpaquePointer?,
        eventAction: (OpaquePointer, UnsafePointer<CChar>, es_mute_path_type_t, UnsafePointer<es_event_type_t>, Int) -> es_return_t,
        globalAction: (OpaquePointer, UnsafePointer<CChar>, es_mute_path_type_t) -> es_return_t
    ) {
        guard let client else { return }
        // Event specific
        for rule in muteSet.eventSpecificRules {
            for path in rule.paths {
                _ = eventAction(client, path, rule.muteType, [rule.eventType], 1)
            }
        }
        
        // Global
        for rule in muteSet.globalRules {
            for path in rule.paths {
                _ = globalAction(client, path, rule.pathType)
            }
        }
    }
}



// MARK: - Path muting XPC operations
/// Extension of the ESM which enables path muting at the ES level.
///
/// **Functionality Covers:**
///   - Getting globally muted paths
///   - Muting a path
///   - Unmuting a path
///   - Reset back to the default mute set
///
extension EndpointSecurityManager {
    // MARK: - Agent Context
    
    public func simpleGetAppleMuteSet() -> [String] { Array(appleMuteSet) }
    
    public func simpleGetMutedPaths() -> [String] {
        return Array(self.globallyMutedPaths.sorted(by: <))
    }
    
    public func requestAppleMuteSet(_ completion: ((Set<String>) -> Void)? = nil) {
        RCXPCConnection.rcXPCConnection.getAppleMuteSet(epDelegate: self) { response in
            DispatchQueue.main.async {
                self.appleMuteSet = response
                completion?(response)
            }
        }
    }
    
    // MARK: Step #1 in getting the list of muted paths from Endpoint Security
    public func requestMutedPaths() {
        RCXPCConnection.rcXPCConnection.getMutedPaths(epDelegate: self) { response in
            DispatchQueue.main.async {
                // Reset
                self.globallyMutedPaths = Set<String>()
                
                // Decode JSON path object
                for jsonPath in response {
                    let parsedPath: ESMutedPath? = decodePathJSON(pathJSON: jsonPath)
                    if let _ = parsedPath {
                        self.globallyMutedPaths.insert(jsonPath)
                    } else{
                        os_log("Error parsing muted path")
                    }
                    
                }
            }
        }
    }
    
    // MARK: Step #2 in muting paths
    // @note send across paths that should be muted by the Endpoint Security client
    public func puntPathToMute(pathToMute: String, muteCase: es_mute_path_type_t, pathEvents: [String]) {
        //        os_log("Punting muting request over XPC!")
        RCXPCConnection.rcXPCConnection.mutePath(pathToMute: pathToMute, muteCase: muteCase, pathEvents: pathEvents, epDelegate: self)
    }
    
    // MARK: Step #2 in unmuting paths
    public func puntPathToUnmute(pathToUnmute: String, type: String, events: [String]) {
        //        os_log("Punting unmuting request over XPC!")
        RCXPCConnection.rcXPCConnection.unmutePaths(pathToUnmute: pathToUnmute, type: type, events: events, epDelegate: self)
    }
    
    // MARK: Step #2 in reseting to the default mute set
    public func resetMuteSetToDefault() {
        //        os_log("Punting reset mute request over XPC!")
        RCXPCConnection.rcXPCConnection.resetMutePaths(epDelegate: self)
    }
    
    
    
    // MARK: - Sensor Context
    
    public func seGetGlobalMutedPaths() -> Set<String> {
        if self.esClient != nil {
            // Submit the fetch request to endpoint security
            var fetchedPaths: UnsafeMutablePointer<es_muted_paths_t>? = fetch_muted_paths(esClient)
            
            if fetchedPaths == nil {
                os_log("The paths we fetched from ES are nil!")
            } else {
                self.globallyMutedPaths = Set<String>()
                for index in 0..<fetchedPaths!.pointee.count {
                    let esJSONPath: String = pathToJSON(value: ESMutedPath(fromRawESPath: fetchedPaths!.pointee.paths[index]))
                    self.globallyMutedPaths.insert(esJSONPath)
                    
                }
                
                release_es_memory(fetchedPaths)
                fetchedPaths = nil
                return self.globallyMutedPaths
                
            }
        } else {
            os_log("There is no client to fetch the muted paths from !")
        }
        
        return self.globallyMutedPaths
    }
    
    
    
    // MARK: Step #4 in muting paths
    public func mutePath(pathToMute: String, muteCase: es_mute_path_type_t, pathEvents: [String]) {
        let typeString: String = getMuteCaseString(muteType: muteCase)
        
        let mutingRequest: es_return_t
        if self.esClient != nil {
            if pathToMute.count > 0 {
                // Submit the mute request to our endpoint security client
                // TODO: Implement the mute with path events
                //                os_log("ENDPOINT SECURITY :: Submitting path muting request \(typeString): `\(pathToMute)` for \(pathEvents.count) events")
                if pathEvents.isEmpty {
                    mutingRequest = es_mute_path(self.esClient!, pathToMute, muteCase)
                } else {
                    // Convert the listing of Endpoint Security event type strings to es_event_type_t
                    var esEventTypes: [es_event_type_t] = []
                    for event in pathEvents {
                        esEventTypes.append(eventStringToType(from: event))
                    }
                    mutingRequest = es_mute_path_events(self.esClient!, pathToMute, muteCase, esEventTypes, esEventTypes.count)
                }
                
                switch (mutingRequest) {
                case ES_RETURN_SUCCESS:
                    //                    os_log("Successfully muted: \(pathToMute) for type: \(typeString)")
                    self.globallyMutedPaths.insert(pathToMute)
                    break
                case ES_RETURN_ERROR:
                    os_log("Error muting path: \(pathToMute) for type: \(typeString)")
                    break
                default:
                    os_log("Unkown error occured while muting path: \(pathToMute)")
                }
            }
        } else {
            os_log("There is no endpoint security client to submit this muting request to!")
        }
    }
    
    // MARK: Step #4 in unmuting paths
    public func unmutePath(pathToUnmute: String, type: String, events: [String]) {
        if self.esClient != nil {
            if pathToUnmute.count > 0 {
                // Submit the unmute request to our endpoint security client
                // Restores event delivery from a previously-muted path.
                let muteType: es_mute_path_type_t = getMuteCaseFromString(muteString: type)
                //                os_log("ENDPOINT SECURITY :: UNMUTING PATH \(type): \(pathToUnmute) for \(events.count) events")
                
                let unmutingRequest: es_return_t
                if events.count > 0 {
                    // Convert the list of events back to es_event_type_ts
                    var eventTypeListing: [es_event_type_t] = []
                    for esEventString in events {
                        eventTypeListing.append(eventStringToType(from: esEventString))
                    }
                    unmutingRequest = es_unmute_path_events(self.esClient!, pathToUnmute, muteType, eventTypeListing, eventTypeListing.count)
                } else {
                    unmutingRequest = es_unmute_path(self.esClient!, pathToUnmute, muteType)
                }
                
                switch (unmutingRequest) {
                case ES_RETURN_SUCCESS:
                    //                    os_log("Successfully unmuted: \(type): \(pathToUnmute)")
                    break
                case ES_RETURN_ERROR:
                    os_log("Error unmuting path: \(type): \(pathToUnmute)")
                    break
                default:
                    os_log("Unkown error occured while unmuting path: \(type): \(pathToUnmute)")
                }
            }
            
        } else {
            os_log("There is no client to submit this unmuting request to!")
        }
    }
}


