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
    /// Given an `es_client_t` apply the default Mac Monitor path mute set.
    ///
    /// The mute set applied is global and per-event.
    ///
    /// - Parameters:
    ///   - client: An Endpoint Security client `es_client_t`
    public static func applyDefaultMuteSet(client: OpaquePointer?) {
        /// This directiory is for the following events:
        /// - `ES_EVENT_TYPE_NOTIFY_RENAME`
        let caches_dir: String = String(FileManager.default.consoleUserHome!.appending(path: "Library/Caches").absoluteString.trimmingPrefix("file://"))
        
        let config = [
            (eventType: ES_EVENT_TYPE_NOTIFY_CREATE, muteType: ES_MUTE_PATH_TYPE_LITERAL, paths: [
                "/usr/sbin/cfprefsd",
                "/usr/libexec/logd",
                "/System/Library/PrivateFrameworks/PackageKit.framework/Versions/A/Resources/system_installd",
                "/System/Library/Frameworks/AddressBook.framework/Versions/A/Helpers/AddressBookManager.app/Contents/MacOS/AddressBookManager"
            ]),
            
            (eventType: ES_EVENT_TYPE_NOTIFY_CREATE, muteType: ES_MUTE_PATH_TYPE_TARGET_PREFIX, paths: [
                caches_dir,
                "/System/Library/PrivateFrameworks/BiomeStreams.framework"
            ]),
            (eventType: ES_EVENT_TYPE_NOTIFY_RENAME, muteType: ES_MUTE_PATH_TYPE_LITERAL, paths: [
                "/usr/sbin/cfprefsd",
                "/usr/libexec/logd"
            ]),
            (eventType: ES_EVENT_TYPE_NOTIFY_RENAME, muteType: ES_MUTE_PATH_TYPE_TARGET_PREFIX, paths: [caches_dir]),
            (eventType: ES_EVENT_TYPE_NOTIFY_OPEN, muteType: ES_MUTE_PATH_TYPE_PREFIX, paths: [
                "/usr/libexec/xpcproxy",
                "/usr/sbin/cfprefsd",
                "/Library/SystemExtensions/",
                "/System/Library/CoreServices/Spotlight.app",
                "/Library/SystemExtensions/",
                "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/Metadata.framework",
                "/System/Library/PrivateFrameworks/SkyLight.framework",
                "/System/Library/PrivateFrameworks/AXAssetLoader.framework",
                "/System/Library/Frameworks/AudioToolbox.framework",
                "/System/Library/PrivateFrameworks/SiriTTSService.framework",
                "/System/Library/PrivateFrameworks/TCC.framework"
            ]),
            (eventType: ES_EVENT_TYPE_NOTIFY_WRITE, muteType: ES_MUTE_PATH_TYPE_PREFIX, paths: [
                "/Library/SystemExtensions/",
                "/usr/libexec/lsd",
                "/usr/sbin/cfprefsd",
                "/System/Library/CoreServices/Spotlight.app",
                "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/Metadata.framework",
                "/usr/sbin/systemstats"
            ]),
            (eventType: ES_EVENT_TYPE_NOTIFY_CLOSE, muteType: ES_MUTE_PATH_TYPE_PREFIX, paths: [
                "/Library/SystemExtensions/",
                "/usr/libexec/lsd",
                "/usr/sbin/cfprefsd",
                "/usr/libexec/xpcproxy",
                "/System/Library/CoreServices/Spotlight.app",
                "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/Metadata.framework",
                "/System/Library/PrivateFrameworks/AXAssetLoader.framework",
                "/System/Library/PrivateFrameworks/SiriTTSService.framework",
                "/System/Library/CoreServices/NotificationCenter.app",
                "/usr/sbin/systemstats",
                "/System/Library/PrivateFrameworks/TCC.framework",
                "/usr/libexec/mobileassetd",
                "/System/Library/PrivateFrameworks/SkyLight.framework",
                "/System/Library/Frameworks/AudioToolbox.framework",
                "/System/Library/PrivateFrameworks/BiomeStreams.framework",
                "/System/Library/CoreServices/ManagedClient.app",
                "/System/Library/Frameworks/Contacts.framework",
                "/System/Library/Frameworks/VideoToolbox.framework",
                "/System/Library/PrivateFrameworks/CoreDuetContext.framework",
                "/System/Library/CoreServices/diagnostics_agent"
            ]),
            (eventType: ES_EVENT_TYPE_NOTIFY_MMAP, muteType: ES_MUTE_PATH_TYPE_LITERAL, paths: [
                "/usr/bin/tailspin",
                "/usr/libexec/spindump",
                "/private/var/db/KernelExtensionManagement/KernelCollections/BootKernelCollection.kc",
                "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/Metadata.framework/Versions/A/Support/mdworker_shared",
                "/usr/libexec/knowledge-agent",
                "/usr/libexec/locationd",
                "/System/Library/PrivateFrameworks/HelpData.framework/Versions/A/Resources/helpd",
                "/System/Library/PrivateFrameworks/BiomeStreams.framework/Support/BiomeAgent",
                "/usr/libexec/xpcproxy",
                "/usr/libexec/opendirectoryd"
            ]),
            (eventType: ES_EVENT_TYPE_NOTIFY_MMAP, muteType: ES_MUTE_PATH_TYPE_TARGET_PREFIX, paths: [
                "/Library/Caches/",
                "/private/var/db/",
                "/System/Volumes/Preboot/Cryptexes/OS/System/Library/dyld/",
                "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/Metadata.framework"
            ]),
            (eventType: ES_EVENT_TYPE_NOTIFY_DUP, muteType: ES_MUTE_PATH_TYPE_TARGET_LITERAL, paths: [
                "/dev/null",
                "/dev/console"
            ]),
            (eventType: ES_EVENT_TYPE_NOTIFY_DUP, muteType: ES_MUTE_PATH_TYPE_PREFIX, paths: [
                "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/Metadata.framework",
                "/System/Library/PrivateFrameworks/BiomeStreams.framework"
            ]),
            (eventType: ES_EVENT_TYPE_NOTIFY_DUP, muteType: ES_MUTE_PATH_TYPE_LITERAL, paths: [
                "/usr/libexec/xpcproxy",
                "/usr/sbin/cfprefsd"
            ]),
            (eventType: ES_EVENT_TYPE_NOTIFY_PROC_CHECK, muteType: ES_MUTE_PATH_TYPE_PREFIX, paths: [
                "/usr/libexec/sysmond",
                "/Applications/Xcode.app",
                "/usr/sbin/systemstats",
                "/System/Library/PrivateFrameworks/CoreDuetContext.framework",
                "/System/Library/PrivateFrameworks/CoreAnalytics.framework",
                "/usr/sbin/mDNSResponder",
                "/usr/libexec/trustd",
                "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/Metadata.framework",
                "/usr/sbin/distnoted",
                "/usr/libexec/mobileassetd",
                "/System/Library/PrivateFrameworks/SiriTTSService.framework",
                "/usr/sbin/cfprefsd",
                "/usr/libexec/xpcproxy",
                "/System/Library/PrivateFrameworks/DataAccess.framework",
                "/System/Library/Frameworks/Contacts.framework",
                "/System/Library/Frameworks/Accounts.framework",
                "/System/Library/PrivateFrameworks/CalendarDaemon.framework",
                "/System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ATS.framework"
            ]),
            (eventType: ES_EVENT_TYPE_NOTIFY_CREATE, muteType: ES_MUTE_PATH_TYPE_TARGET_PREFIX, paths: []),
            (eventType: ES_EVENT_TYPE_NOTIFY_MMAP, muteType: ES_MUTE_PATH_TYPE_PREFIX, paths: [
                "/Applications/Xcode.app/Contents/SharedFrameworks"
            ]),
            (eventType: ES_EVENT_TYPE_NOTIFY_EXIT, muteType: ES_MUTE_PATH_TYPE_PREFIX, paths: [
                "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/Metadata.framework"
            ]),
            (eventType: ES_EVENT_TYPE_NOTIFY_PROC_CHECK, muteType: ES_MUTE_PATH_TYPE_LITERAL, paths: [
                "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/Metadata.framework",
                "/usr/libexec/airportd",
                "/usr/libexec/usermanagerd",
                "/usr/libexec/containermanagerd",
                "/System/Library/PrivateFrameworks/CloudKitDaemon.framework/support/cloudd",
                "/usr/libexec/rosetta/oahd"
            ]),
            (eventType: ES_EVENT_TYPE_NOTIFY_IOKIT_OPEN, muteType: ES_MUTE_PATH_TYPE_LITERAL, paths: [
                "/usr/libexec/PerfPowerServices"
            ])
        ]
        
        for (eventType, muteType, paths) in config {
            for path in paths {
                es_mute_path_events(client!, path, muteType, [eventType], 1)
            }
        }
        
        if #available(macOS 14, *) {
            // MARK: macOS 14 specific
            let sonomaConfig = [
                (eventType: ES_EVENT_TYPE_NOTIFY_XPC_CONNECT, muteType: ES_MUTE_PATH_TYPE_LITERAL, paths: [
                    "/usr/sbin/bluetoothd",
                    "/usr/libexec/airportd"
                ])
            ]
            
            for (eventType, muteType, paths) in sonomaConfig {
                for path in paths {
                    es_mute_path_events(client!, path, muteType, [eventType], 1)
                }
            }
        }
        
        let globalConfig = [
            (pathType: ES_MUTE_PATH_TYPE_LITERAL, paths: [
                "/usr/libexec/logd",
                "/System/Library/CoreServices/Diagnostics Reporter.app/Contents/MacOS/Diagnostics Reporter",
                "/usr/libexec/ReportMemoryException",
                "/usr/sbin/spindump",
                "/System/Library/PrivateFrameworks/BiomeStreams.framework/Support/BiomeAgent",
                "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/Metadata.framework/Versions/A/Support/mdworker_shared",
                "/usr/libexec/duetexpertd"
            ]),
            (pathType: ES_MUTE_PATH_TYPE_PREFIX, paths: [
                "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain",
                "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/Metadata.framework"
            ]),
            (pathType: ES_MUTE_PATH_TYPE_TARGET_LITERAL, paths: [
//                "/usr/libexec/xpcproxy",
                "/usr/sbin/spindump",
                "/usr/libexec/tailspind",
                "/dev/null",
                "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/Metadata.framework/Versions/A/Support/mdworker_shared"
            ])
        ]
        
        for (pathType, paths) in globalConfig {
            for path in paths {
                es_mute_path(client!, path, pathType)
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
    
    public func simpleGetMutedPaths() -> [String] {
        // @note sorting the listing of muted paths in decending order
        return Array(self.globallyMutedPaths.sorted(by: <))
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
                    if parsedPath != nil {
                        //                        os_log("Decoded ES muted path: `\(parsedPath!.path)` as \(parsedPath!.type) targeting \(parsedPath!.eventCount) events: \(parsedPath!.events)")
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
    public func resetMuteSetToDefaultRCSet() {
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
                // Insert into the global ESMuted
                for index in 0..<fetchedPaths!.pointee.count {
                    let esJSONPath: String = pathToJSON(value: ESMutedPath(fromRawESPath: fetchedPaths!.pointee.paths[index]))
                    self.globallyMutedPaths.insert(esJSONPath)
                }
                
                // Frees resources associated with a set of previously-retrieved muted paths.
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


