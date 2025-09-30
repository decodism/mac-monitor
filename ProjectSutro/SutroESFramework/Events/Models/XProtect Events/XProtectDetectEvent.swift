//
//  XProtectDetectEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/13/23.
//

import Foundation
import EndpointSecurity


// MARK: - XProtect Malware Detected event model: https://developer.apple.com/documentation/endpointsecurity/es_event_xp_malware_detected_t
public struct XProtectDetectEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    public var signature_version: String = "Unknown"
    public var malware_identifier: String = "Unknown"
    public var incident_identifier: String = "Unknown"
    public var detected_path: String = "Unknown"
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(incident_identifier)
        hasher.combine(detected_path)
        hasher.combine(id)
    }
    
    public static func == (lhs: XProtectDetectEvent, rhs: XProtectDetectEvent) -> Bool {
        if lhs.incident_identifier == rhs.incident_identifier && lhs.id == rhs.id {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let xprotectDetectEvent: UnsafeMutablePointer<es_event_xp_malware_detected_t> = rawMessage.pointee.event.xp_malware_detected
        self.signature_version = String(cString: xprotectDetectEvent.pointee.signature_version.data)
        self.malware_identifier = String(cString: xprotectDetectEvent.pointee.malware_identifier.data)
        self.incident_identifier = String(cString: xprotectDetectEvent.pointee.incident_identifier.data)
        self.detected_path = String(cString: xprotectDetectEvent.pointee.detected_path.data)
    }
}
