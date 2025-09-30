//
//  SSHLoginEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/13/23.
//

import Foundation
import EndpointSecurity
import OSLog


// MARK: - OpenSSH Login event model: https://developer.apple.com/documentation/endpointsecurity/3228936-es_events_t/3930481-openssh_login
public struct SSHLoginEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    public var result_type: String
    public var source_address: String = "Unknown"
    public var source_address_type: String = "Unknown"
    public var success: Bool
    public var user_name: String = "Unknown"
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(source_address)
        hasher.combine(result_type)
        hasher.combine(id)
    }
    
    public static func == (lhs: SSHLoginEvent, rhs: SSHLoginEvent) -> Bool {
        if lhs.source_address == rhs.source_address && lhs.result_type == rhs.result_type && lhs.user_name == rhs.user_name {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let sshLoginEvent: UnsafeMutablePointer<es_event_openssh_login_t> = rawMessage.pointee.event.openssh_login
        // MARK: OpenSSH login success?
        self.success = sshLoginEvent.pointee.success
        
        // MARK: Login username
        if sshLoginEvent.pointee.username.length > 0 {
            self.user_name = String(cString: sshLoginEvent.pointee.username.data)
        }
        
        // MARK: Source address of the OpenSSH connection
        if sshLoginEvent.pointee.source_address.length > 0 {
            self.source_address = String(cString: sshLoginEvent.pointee.source_address.data)
        }
        
        // MARK: Determine the source address type of the OpenSSH login event
        switch(sshLoginEvent.pointee.source_address_type) {
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
        
        // MARK: Determine the result of the OpenSSH login event
        switch(sshLoginEvent.pointee.result_type) {
        case ES_OPENSSH_AUTH_SUCCESS:
            self.result_type = "ES_OPENSSH_AUTH_SUCCESS"
            break
        case ES_OPENSSH_LOGIN_EXCEED_MAXTRIES:
            self.result_type = "ES_OPENSSH_LOGIN_EXCEED_MAXTRIES"
            break
        case ES_OPENSSH_INVALID_USER:
            self.result_type = "ES_OPENSSH_INVALID_USER"
            break
        case ES_OPENSSH_AUTH_FAIL_NONE:
            self.result_type = "ES_OPENSSH_AUTH_FAIL_NONE"
            break
        case ES_OPENSSH_AUTH_FAIL_GSSAPI:
            self.result_type = "ES_OPENSSH_AUTH_FAIL_GSSAPI"
            break
        case ES_OPENSSH_AUTH_FAIL_KBDINT:
            self.result_type = "ES_OPENSSH_AUTH_FAIL_KBDINT"
            break
        case ES_OPENSSH_AUTH_FAIL_PASSWD:
            self.result_type = "ES_OPENSSH_AUTH_FAIL_PASSWD"
            break
        case ES_OPENSSH_AUTH_FAIL_PUBKEY:
            self.result_type = "ES_OPENSSH_AUTH_FAIL_PUBKEY"
            break
        case ES_OPENSSH_LOGIN_ROOT_DENIED:
            self.result_type = "ES_OPENSSH_LOGIN_ROOT_DENIED"
            break
        case ES_OPENSSH_AUTH_FAIL_HOSTBASED:
            self.result_type = "ES_OPENSSH_AUTH_FAIL_HOSTBASED"
            break
        default:
            self.result_type = "Unknown"
            break
        }
    }
}
