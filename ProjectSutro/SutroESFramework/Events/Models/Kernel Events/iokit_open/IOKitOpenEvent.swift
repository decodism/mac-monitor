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
    
    public var user_client_type: Int64
    public var user_client_class: String
    
    /* fields available only if message version >= 10 */
    public var parent_registry_id: Int64 = 0
    public var parent_path: String?
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: IOKitOpenEvent, rhs: IOKitOpenEvent) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let ioKitEvent: es_event_iokit_open_t = rawMessage.pointee.event.iokit_open
        let version: Int = Int(rawMessage.pointee.version)
        
        self.user_client_class = ""
        if ioKitEvent.user_client_class.length > 0 {
            self.user_client_class = String(cString: ioKitEvent.user_client_class.data)
        }
        self.user_client_type = Int64(ioKitEvent.user_client_type)
        
        if version >= 10 {
            self.parent_registry_id = Int64(ioKitEvent.parent_registry_id)
            self.parent_path = ioKitEvent.parent_path.toString()
        }
    }
}
