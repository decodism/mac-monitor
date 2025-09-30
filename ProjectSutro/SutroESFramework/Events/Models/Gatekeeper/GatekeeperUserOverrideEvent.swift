//
//  GatekeeperUserOverrideEvent.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 8/18/25.
//

import Foundation
import EndpointSecurity


// MARK: - Gatekeeper User Override event model: https://developer.apple.com/documentation/endpointsecurity/es_event_gatekeeper_user_override_t
// Available beginning in macOS 15.0
public struct GatekeeperUserOverrideEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    /// `es_gatekeeper_user_override_file_type_t`
    public var file_type: Int32
    public var file_type_string: String
    
    /// File union
    public var file: FilePathUnion
    public var sha256: String?
    
    public var signing_info: SignedFileInfo?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(sha256)
        hasher.combine(id)
    }
    
    public static func == (lhs: GatekeeperUserOverrideEvent, rhs: GatekeeperUserOverrideEvent) -> Bool {
        if lhs.sha256 == rhs.sha256 && lhs.id == rhs.id {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let gatekeeperOverrideEvent: es_event_gatekeeper_user_override_t = rawMessage.pointee.event.gatekeeper_user_override.pointee
        
        file_type = Int32(gatekeeperOverrideEvent.file_type.rawValue)
        switch(gatekeeperOverrideEvent.file_type) {
        case ES_GATEKEEPER_USER_OVERRIDE_FILE_TYPE_PATH:
            file_type_string = "ES_GATEKEEPER_USER_OVERRIDE_FILE_TYPE_PATH"
        case ES_GATEKEEPER_USER_OVERRIDE_FILE_TYPE_FILE:
            file_type_string = "ES_GATEKEEPER_USER_OVERRIDE_FILE_TYPE_FILE"
        default:
            file_type_string = "Unknown"
        }
        
        file = FilePathUnion.from(override: gatekeeperOverrideEvent)
        if let sha256 = gatekeeperOverrideEvent.sha256 {
            self.sha256 = sha256HexString(sha256.pointee)
        }
        
        if let signingInfo = gatekeeperOverrideEvent.signing_info {
            signing_info = SignedFileInfo(from: signingInfo.pointee)
        }
    }
}
