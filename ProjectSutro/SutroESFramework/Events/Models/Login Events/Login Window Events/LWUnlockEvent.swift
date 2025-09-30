//
//  LWUnlockEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/18/23.
//

import Foundation


// https://developer.apple.com/documentation/endpointsecurity/es_event_lw_session_unlock_t
public struct LWUnlockEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    public var username: String
    public var graphical_session_id: Int32
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(username)
        hasher.combine(id)
    }
    
    public static func == (lhs: LWUnlockEvent, rhs: LWUnlockEvent) -> Bool {
        if lhs.graphical_session_id == rhs.graphical_session_id && lhs.id == rhs.id && lhs.username == rhs.username {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let lwUnlockEvent: es_event_lw_session_unlock_t = rawMessage.pointee.event.lw_session_unlock.pointee
        
        self.username = String(cString: lwUnlockEvent.username.data)
        self.graphical_session_id = Int32(lwUnlockEvent.graphical_session_id)
    }
}
