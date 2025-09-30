//
//  LoginLoginEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/17/23.
//

import Foundation
import EndpointSecurity
import OSLog


// https://developer.apple.com/documentation/endpointsecurity/es_event_login_login_t
public struct LoginLoginEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    public var succcess: Bool
    public var failure_message, username, uid_human: String
    public var uid: Int64
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(username)
        hasher.combine(id)
    }
    
    public static func == (lhs: LoginLoginEvent, rhs: LoginLoginEvent) -> Bool {
        if lhs.succcess == rhs.succcess && lhs.username == rhs.username && lhs.id == rhs.id {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let loginLoginEvent: es_event_login_login_t = rawMessage.pointee.event.login_login.pointee
    
        self.succcess = loginLoginEvent.success
        if !loginLoginEvent.success &&  loginLoginEvent.failure_message.length > 0 {
            self.failure_message = String(cString: loginLoginEvent.failure_message.data)
        } else {
            self.failure_message = ""
        }
        
        self.username = String(cString: loginLoginEvent.username.data)
        if loginLoginEvent.has_uid {
            self.uid = Int64(loginLoginEvent.uid.uid)
            self.uid_human = String(cString: getpwuid(uid_t(loginLoginEvent.uid.uid))!.pointee.pw_name)
        } else {
            self.uid = -1
            self.uid_human = "Unknown"
        }
        
    }
}
