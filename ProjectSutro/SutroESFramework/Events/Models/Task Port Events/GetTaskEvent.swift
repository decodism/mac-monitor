//
//  GetTaskEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/3/23.
//

import Foundation
import EndpointSecurity



// MARK: - Get Task Event https://developer.apple.com/documentation/endpointsecurity/es_event_get_task_t
public struct GetTaskEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    public var process_name, process_path, signing_id, audit_token, type: String?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(process_path)
        hasher.combine(signing_id)
        hasher.combine(audit_token)
        hasher.combine(type)
    }
    
    public static func == (lhs: GetTaskEvent, rhs: GetTaskEvent) -> Bool {
        if lhs.process_path == rhs.process_path && lhs.signing_id == rhs.signing_id && lhs.audit_token == rhs.audit_token && lhs.type == rhs.type {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let getTaskEvent: es_event_get_task_t = rawMessage.pointee.event.get_task
        
        // MARK: - Basic process metadata
        self.process_path = ""
        self.process_name = ""
        self.signing_id = ""
        self.audit_token = ""
        self.type = ""
        
        if getTaskEvent.target.pointee.executable.pointee.path.length > 0 {
            let processURL: NSURL = NSURL(fileURLWithPath: String(cString: getTaskEvent.target.pointee.executable.pointee.path.data))
            self.process_path =  String(cString: getTaskEvent.target.pointee.executable.pointee.path.data)
            self.process_name = processURL.lastPathComponent
        }
        
        // @note audit tokens
        self.audit_token = getTaskEvent.target.pointee.audit_token.toString()
        
        
        switch(getTaskEvent.type) {
        case ES_GET_TASK_TYPE_EXPOSE_TASK:
            self.type = "ES_GET_TASK_TYPE_EXPOSE_TASK"
        case ES_GET_TASK_TYPE_IDENTITY_TOKEN:
            self.type = "ES_GET_TASK_TYPE_IDENTITY_TOKEN"
        case ES_GET_TASK_TYPE_TASK_FOR_PID:
            self.type = "ES_GET_TASK_TYPE_TASK_FOR_PID"
        default:
            self.type = "UNKNOWN"
        }
       
    }
}
