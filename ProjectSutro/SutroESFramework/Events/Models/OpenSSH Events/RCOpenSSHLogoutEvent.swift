//
//  OpenSSHLogoutEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/13/23.
//

import Foundation
import EndpointSecurity
import OSLog


// MARK: - OpenSSH Logout event model: https://developer.apple.com/documentation/endpointsecurity/3228936-es_events_t/3930482-openssh_logout
public struct SSHLogoutEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    public var source_address: String = "Unknown"
    public var source_address_type: String = "Unknown"
    public var username: String = "Unknown"
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(source_address)
        hasher.combine(source_address_type)
        hasher.combine(username)
        hasher.combine(id)
    }
    
    public static func == (lhs: SSHLogoutEvent, rhs: SSHLogoutEvent) -> Bool {
        if lhs.source_address == rhs.source_address && lhs.username == rhs.username && lhs.source_address_type == rhs.source_address_type {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let sshLogoutEvent: UnsafeMutablePointer<es_event_openssh_logout_t> = rawMessage.pointee.event.openssh_logout
        
        // MARK: Logout username
        if sshLogoutEvent.pointee.username.length > 0 {
            self.username = String(cString: sshLogoutEvent.pointee.username.data)
        }
        
        // MARK: Source address of the OpenSSH connection
        if sshLogoutEvent.pointee.source_address.length > 0 {
            self.source_address = String(cString: sshLogoutEvent.pointee.source_address.data)
        }
        
        // MARK: Determine the source address type of the OpenSSH logout event
        switch(sshLogoutEvent.pointee.source_address_type) {
        case ES_ADDRESS_TYPE_NONE:
            self.source_address_type = "ES_ADDRESS_TYPE_NONE"
            break
        case ES_ADDRESS_TYPE_IPV4:
            self.source_address_type = "ES_ADDRESS_TYPE_IPV4"
            break
        case ES_ADDRESS_TYPE_IPV6:
            self.source_address_type = "ES_ADDRESS_TYPE_IPV6"
            break
        case ES_ADDRESS_TYPE_NAMED_SOCKET:
            self.source_address_type = "ES_ADDRESS_TYPE_NAMED_SOCKET"
            break
        default:
            self.source_address_type = "Unknown"
            break
        }
    }
}
