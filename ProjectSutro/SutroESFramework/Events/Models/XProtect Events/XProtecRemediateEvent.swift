//
//  XProtecRemediateEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/13/23.
//

import Foundation
import EndpointSecurity


// MARK: - XProtect Malware Remediated event model: https://developer.apple.com/documentation/endpointsecurity/es_event_xp_malware_remediated_t
public struct XProtecRemediateEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    public var signature_version: String
    public var malware_identifier: String
    public var incident_identifier: String
    public var action_type: String
    public var success: Bool
    public var result_description: String
    public var remediated_path: String
    public var remediated_process_audit_token: AuditToken?
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: XProtecRemediateEvent, rhs: XProtecRemediateEvent) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let event: es_event_xp_malware_remediated_t = rawMessage.pointee.event.xp_malware_remediated.pointee
        
        self.signature_version = event.signature_version.toString() ?? ""
        self.malware_identifier = event.malware_identifier.toString()  ?? ""
        self.incident_identifier = event.incident_identifier.toString()  ?? ""
        self.action_type = event.action_type.toString() ?? ""
        self.success = event.success
        self.result_description = event.result_description.toString() ?? ""
        self.remediated_path = event.remediated_path.toString() ?? ""
        
        if let remediated_process_audit_token = event.remediated_process_audit_token {
            self.remediated_process_audit_token = AuditToken(from: remediated_process_audit_token.pointee)
        }
    }
}
