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
    
    public var succcess, has_uid: Bool
    public var failure_message, username, uid_human: String
    public var uid: Int64
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: LoginLoginEvent, rhs: LoginLoginEvent) -> Bool {
        return lhs.id == rhs.id
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
        self.has_uid = loginLoginEvent.has_uid
        if loginLoginEvent.has_uid {
            self.uid = Int64(loginLoginEvent.uid.uid)
            self.uid_human = String(cString: getpwuid(uid_t(loginLoginEvent.uid.uid))!.pointee.pw_name)
        } else {
            self.uid = -1
            self.uid_human = "Unknown"
        }
    }
}
