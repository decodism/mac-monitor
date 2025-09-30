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
    public var signature_version: String = "Unknown"
    public var malware_identifier: String = "Unknown"
    public var incident_identifier: String = "Unknown"
    public var action_type: String = "Unknown"
    public var success: Bool = false
    public var result_description: String = "Unknown"
    public var remediated_path: String = "Unknown"
    public var remediated_process_audit_token: String = "Unknown"
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(incident_identifier)
        hasher.combine(remediated_process_audit_token)
        hasher.combine(id)
    }
    
    public static func == (lhs: XProtecRemediateEvent, rhs: XProtecRemediateEvent) -> Bool {
        if lhs.incident_identifier == rhs.incident_identifier && lhs.id == rhs.id {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let xprotectRemediateEvent: UnsafeMutablePointer<es_event_xp_malware_remediated_t> = rawMessage.pointee.event.xp_malware_remediated
        self.signature_version = String(cString: xprotectRemediateEvent.pointee.signature_version.data)
        self.malware_identifier = String(cString: xprotectRemediateEvent.pointee.malware_identifier.data)
        self.incident_identifier = String(cString: xprotectRemediateEvent.pointee.incident_identifier.data)
        self.remediated_path = String(cString: xprotectRemediateEvent.pointee.remediated_path.data)
        self.action_type = String(cString: xprotectRemediateEvent.pointee.action_type.data)
        self.success = xprotectRemediateEvent.pointee.success
        self.result_description = String(cString: xprotectRemediateEvent.pointee.result_description.data)
        
        let remediated_proc_audit_token = xprotectRemediateEvent.pointee.remediated_process_audit_token!.pointee.val
        self.remediated_process_audit_token = "\(remediated_proc_audit_token.0) \(remediated_proc_audit_token.1) \(remediated_proc_audit_token.2) \(remediated_proc_audit_token.3) \(remediated_proc_audit_token.4) \(remediated_proc_audit_token.5) \(remediated_proc_audit_token.6) \(remediated_proc_audit_token.7)"
    }
}

public func timespecToTimestamp(timespec: timespec) -> Date {
    let unixTimestamp = Double(timespec.tv_sec) + (Double(timespec.tv_nsec) / 1e9)
    let date = Date(timeIntervalSince1970: unixTimestamp)
    
    return date
}
