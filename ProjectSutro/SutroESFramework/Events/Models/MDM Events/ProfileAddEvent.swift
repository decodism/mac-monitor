//
//  ProfileAddEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 6/5/23.
//

import Foundation


/// Models a `ES_EVENT_TYPE_NOTIFY_PROFILE_ADD` which describes a profile being installed on the system.
///
/// https://developer.apple.com/documentation/endpointsecurity/3228936-es_events_t/4161242-profile_add
///
//@available(macOS, introduced: 14.0)
public struct ProfileAddEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    public var instigator_process_name, instigator_process_path, instigator_process_audit_token, instigator_process_signing_id: String?
    public var is_update: Bool
    public var profile_identifier, profile_uuid, profile_organization, profile_display_name, profile_scope: String?
    public var profile_source_type: String?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(instigator_process_audit_token)
        hasher.combine(id)
        hasher.combine(profile_uuid)
    }
    
    public static func == (lhs: ProfileAddEvent, rhs: ProfileAddEvent) -> Bool {
        if lhs.id == rhs.id && lhs.instigator_process_audit_token == rhs.instigator_process_audit_token && lhs.profile_uuid == rhs.profile_uuid {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let profileAddEvent: es_event_profile_add_t = rawMessage.pointee.event.profile_add.pointee
        let profileInstigatorProcess: es_process_t = rawMessage.pointee.event.profile_add.pointee.instigator!.pointee
        
        // @MARK: Instigator proc
        self.instigator_process_name = ""
        if profileInstigatorProcess.executable.pointee.path.length > 0 {
            self.instigator_process_name = URL(
                filePath: profileInstigatorProcess.executable.pointee.path
                    .toString() ?? ""
            ).lastPathComponent
        }
        
        self.instigator_process_path = profileInstigatorProcess.executable.pointee.path
            .toString()
        
        self.instigator_process_signing_id = profileInstigatorProcess.signing_id
            .toString()
        
        self.instigator_process_audit_token = ""
        self.instigator_process_audit_token = profileInstigatorProcess.audit_token
            .toString()
        
        // MARK: Profile specifics
        self.is_update = profileAddEvent.is_update
        self.profile_identifier = profileAddEvent.profile.pointee.identifier.toString()
        
        self.profile_uuid = profileAddEvent.profile.pointee.uuid.toString()
        self.profile_organization = profileAddEvent.profile.pointee.organization
            .toString()
        self.profile_display_name = profileAddEvent.profile.pointee.display_name
            .toString()
        self.profile_scope = profileAddEvent.profile.pointee.scope
            .toString()
        
        switch(profileAddEvent.profile.pointee.install_source) {
        case ES_PROFILE_SOURCE_INSTALL:
            self.profile_source_type = "ES_PROFILE_SOURCE_INSTALL"
        case ES_PROFILE_SOURCE_MANAGED:
            self.profile_source_type = "ES_PROFILE_SOURCE_MANAGED"
        default:
            self.profile_source_type = ""
        }
    }
}

