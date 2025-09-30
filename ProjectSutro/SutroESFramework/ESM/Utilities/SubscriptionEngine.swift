//
//  SubscriptionEngine.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/7/23.
//

import Foundation
import OSLog


extension EndpointSecurityManager {
    // MARK: Step #1 in getting the list of events we're subscribed to from Endpoint Security
    public func requestEventSubscriptions() {
        RCXPCConnection.rcXPCConnection.getEventSubscriptions(epDelegate: self) { response in
            DispatchQueue.main.async {
                self.monitoredEventStrings = Set<String>()
                for eventString in response {
                    self.monitoredEventStrings.insert(eventString)
                }
            }
        }
    }
    
    public func getSimpleEventSubscriptions() -> [String] {
        return Array(self.monitoredEventStrings.sorted(by: <))
    }
    
    public func getCoreEvents() -> [String] {
        var eventString: [String] = []
        for event in defaultEventSubscriptions {
            eventString.append(eventTypeToString(from: event))
        }
        return eventString
    }
    
    public func seGetEventSubscriptionsAsString() -> Set<String> {
        var eventArrayBuffer: Set<String> = []
        for event in self.monitoredEvents {
            eventArrayBuffer.insert(eventTypeToString(from: event))
        }
        
        return eventArrayBuffer
    }
    
    // MARK: Step #2 in unsubscribing from events
    // @note send across events that should be unsubscribed from by the Endpoint Security client
    public func puntEventToUnsubscribe(eventString: String) {
        //        os_log("Punting ES unsubscribe request over XPC! --> \(eventString)")
        RCXPCConnection.rcXPCConnection.unsubscribeFromEvent(eventToUnsubscribeFrom: eventString, epDelegate: self)
    }
    
    // MARK: Step #2 in subscribing to ES events
    // @note send across events that we should subscrube to
    public func puntEventToSubscribe(eventString: String) {
        //        os_log("Punting ES subscrube request over XPC! --> \(eventString)")
        RCXPCConnection.rcXPCConnection.subscribeToEvent(eventToSubscribeTo: eventString, epDelegate: self)
    }
    
    // MARK: Step #4 in unsubscribing from an ES event
    public func unsubscribeFromEvent(eventToUnsubscribeFrom: String) {
        if self.esClient != nil {
            if eventToUnsubscribeFrom.count > 0 {
                // Submit the "unsubscribe" request to our endpoint security client
                //                os_log("ENDPOINT SECURITY :: UNSUBSCRIBING FROM \(eventToUnsubscribeFrom)")
                let unsubscribeRequest: es_return_t = es_unsubscribe(self.esClient!, [eventStringToType(from: eventToUnsubscribeFrom)], 1)
                
                switch (unsubscribeRequest) {
                case ES_RETURN_SUCCESS:
                    //                    os_log("Successfully unsubscribed from: \(eventToUnsubscribeFrom)")
                    self.monitoredEventStrings.remove(eventToUnsubscribeFrom)
                    self.monitoredEvents = self.monitoredEvents.filter({ $0 != eventStringToType(from: eventToUnsubscribeFrom) })
                    break
                case ES_RETURN_ERROR:
                    os_log("Error unsubscribing from: \(eventToUnsubscribeFrom)")
                    break
                default:
                    os_log("Unknown error occured while unsubscribing from: \(eventToUnsubscribeFrom)")
                }
            }
            
        } else {
            os_log("There is no client to submit this unsubscribe request to!")
        }
    }
    
    // MARK: Step #4 in subscribing to ES events
    public func subscribeToEvent(eventToSubscribeTo: String) {
        let subscribeRequest: es_return_t
        if self.esClient != nil {
            if eventToSubscribeTo.count > 0 {
                //                os_log("ENDPOINT SECURITY :: Submitting path subscribe request \(eventToSubscribeTo)")
                subscribeRequest = es_subscribe(self.esClient!, [eventStringToType(from: eventToSubscribeTo)], 1)
                
                switch (subscribeRequest) {
                case ES_RETURN_SUCCESS:
                    //                    os_log("Successfully subscribed to: \(eventToSubscribeTo)")
                    self.monitoredEventStrings.insert(eventToSubscribeTo)
                    self.monitoredEvents.append(eventStringToType(from: eventToSubscribeTo))
                    break
                case ES_RETURN_ERROR:
                    os_log("Error subscribing to event: \(eventToSubscribeTo)")
                default:
                    os_log("Unkown error occured while subscribing to: \(eventToSubscribeTo)")
                }
            }
        } else {
            os_log("There is no endpoint security client to submit this subscribe request to!")
        }
    }
}
