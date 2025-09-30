//
//  ProcessCheckEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/3/23.
//

import Foundation
import EndpointSecurity


/**
 * @brief Access control check for retrieving process information.
 *
 * @field target The process for which the access will be checked
 * @field type The type of call number used to check the access on the target process
 * @field flavor The flavor used to check the access on the target process
 *
 * @note Cache key for this event type:  (process executable file, target process executable file, type)
 */
// MARK: - Process check https://developer.apple.com/documentation/endpointsecurity/es_event_proc_check_t
public struct ProcessCheckEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    public var target: Process?
    public var type: Int32
    public var type_string: String
    public var flavor: Int
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(type_string)
        hasher.combine(flavor)
        hasher.combine(id)
        
        if let target = target {
            hasher.combine(target.audit_token_string)
        }
    }
    
    public static func == (lhs: ProcessCheckEvent, rhs: ProcessCheckEvent) -> Bool {
        if let lhs_audit_token = lhs.target?.audit_token_string,
           let rhs_audit_token = rhs.target?.audit_token_string {
            if lhs_audit_token != rhs_audit_token {
                return false
            }
        }
        
        if lhs.type_string != rhs.type_string && lhs.flavor != rhs.flavor {
            return false
        }
        
        return true
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let procCheckEvent: es_event_proc_check_t = rawMessage.pointee.event.proc_check
        
        if let target = procCheckEvent.target {
            self.target = Process(from: target.pointee, version: Int(rawMessage.pointee.version))
        }
        
        self.flavor = Int(procCheckEvent.flavor)
        
        self.type = Int32(procCheckEvent.type.rawValue)
        
        switch(procCheckEvent.type) {
        case ES_PROC_CHECK_TYPE_PIDINFO:
            self.type_string = "ES_PROC_CHECK_TYPE_PIDINFO"
        case ES_PROC_CHECK_TYPE_LISTPIDS:
            self.type_string = "ES_PROC_CHECK_TYPE_LISTPIDS"
        case ES_PROC_CHECK_TYPE_PIDFDINFO:
            self.type_string = "ES_PROC_CHECK_TYPE_PIDFDINFO"
        case ES_PROC_CHECK_TYPE_PIDRUSAGE:
            self.type_string = "ES_PROC_CHECK_TYPE_PIDRUSAGE"
        case ES_PROC_CHECK_TYPE_TERMINATE:
            self.type_string = "ES_PROC_CHECK_TYPE_TERMINATE"
        case ES_PROC_CHECK_TYPE_KERNMSGBUF:
            self.type_string = "ES_PROC_CHECK_TYPE_KERNMSGBUF"
        case ES_PROC_CHECK_TYPE_SETCONTROL:
            self.type_string = "ES_PROC_CHECK_TYPE_SETCONTROL"
        case ES_PROC_CHECK_TYPE_DIRTYCONTROL:
            self.type_string = "ES_PROC_CHECK_TYPE_DIRTYCONTROL"
        case ES_PROC_CHECK_TYPE_PIDFILEPORTINFO:
            self.type_string = "ES_PROC_CHECK_TYPE_PIDFILEPORTINFO"
        case ES_PROC_CHECK_TYPE_UDATA_INFO:
            self.type_string = "ES_PROC_CHECK_TYPE_UDATA_INFO"
        case ES_PROC_CHECK_TYPE_PIDFILEPORTINFO:
            self.type_string = "ES_PROC_CHECK_TYPE_PIDFILEPORTINFO"
        default:
            self.type_string = "UNKNOWN"
        }
    }
}
