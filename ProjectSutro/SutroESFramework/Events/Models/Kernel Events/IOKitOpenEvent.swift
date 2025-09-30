//
//  IOKitOpenEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/2/23.
//

import Foundation
import EndpointSecurity


// https://developer.apple.com/documentation/endpointsecurity/es_event_iokit_open_t
public struct IOKitOpenEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    public var user_client_class: String?
    public var user_client_type: Int?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(user_client_class)
        hasher.combine(user_client_type)
        hasher.combine(id)
    }
    
    public static func == (lhs: IOKitOpenEvent, rhs: IOKitOpenEvent) -> Bool {
        if lhs.user_client_class == rhs.user_client_class && lhs.user_client_type == rhs.user_client_type && lhs.id == rhs.id {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        // Getting the IOKit event
        let ioKitEvent: es_event_iokit_open_t = rawMessage.pointee.event.iokit_open
        
        self.user_client_class = ""
        if ioKitEvent.user_client_class.length > 0 {
            self.user_client_class = String(cString: ioKitEvent.user_client_class.data)
        }
        self.user_client_type = Int(ioKitEvent.user_client_type)
    }
}
