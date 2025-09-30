//
//  ESProfileAddEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 6/5/23.
//
//

import Foundation
import CoreData

@objc(ESProfileAddEvent)
public class ESProfileAddEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, instigator_process_name, instigator_process_path, instigator_process_audit_token, instigator_process_signing_id, is_update, profile_identifier, profile_uuid, profile_organization, profile_display_name, profile_scope, profile_source_type
    }
    
    // MARK: - Custom initilizer for ESProfileAddEvent during heavy flows
    convenience init(from message: Message) {
        let profileAddEvent: ProfileAddEvent = message.event.profile_add!
        self.init()
        
        self.id = profileAddEvent.id
        self.instigator_process_name = profileAddEvent.instigator_process_name
        self.instigator_process_path = profileAddEvent.instigator_process_path
        self.instigator_process_audit_token = profileAddEvent.instigator_process_audit_token
        self.instigator_process_signing_id = profileAddEvent.instigator_process_signing_id
        self.is_update = profileAddEvent.is_update
        self.profile_identifier = profileAddEvent.profile_identifier
        self.profile_uuid = profileAddEvent.profile_uuid
        self.profile_organization = profileAddEvent.profile_organization
        self.profile_display_name = profileAddEvent.profile_display_name
        self.profile_scope = profileAddEvent.profile_scope
        self.profile_source_type = profileAddEvent.profile_source_type
    }
    
    // MARK: - Custom Core Data initilizer for ESProfileAddEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let profileAddEvent: ProfileAddEvent = message.event.profile_add!
        let description = NSEntityDescription.entity(forEntityName: "ESProfileAddEvent", in: context)!
        self.init(entity: description, insertInto: context)
        
        self.id = profileAddEvent.id
        self.instigator_process_name = profileAddEvent.instigator_process_name
        self.instigator_process_path = profileAddEvent.instigator_process_path
        self.instigator_process_audit_token = profileAddEvent.instigator_process_audit_token
        self.instigator_process_signing_id = profileAddEvent.instigator_process_signing_id
        self.is_update = profileAddEvent.is_update
        self.profile_identifier = profileAddEvent.profile_identifier
        self.profile_uuid = profileAddEvent.profile_uuid
        self.profile_organization = profileAddEvent.profile_organization
        self.profile_display_name = profileAddEvent.profile_display_name
        self.profile_scope = profileAddEvent.profile_scope
        self.profile_source_type = profileAddEvent.profile_source_type
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try instigator_process_name = container.decode(String.self, forKey: .instigator_process_name)
        try instigator_process_path = container.decode(String.self, forKey: .instigator_process_path)
        try instigator_process_audit_token = container.decode(String.self, forKey: .instigator_process_audit_token)
        try instigator_process_signing_id = container.decode(String.self, forKey: .instigator_process_signing_id)
        try is_update = container.decode(Bool.self, forKey: .is_update)
        try profile_identifier = container.decode(String.self, forKey: .profile_identifier)
        try profile_uuid = container.decode(String.self, forKey: .profile_uuid)
        try profile_organization = container.decode(String.self, forKey: .profile_organization)
        try profile_display_name = container.decode(String.self, forKey: .profile_display_name)
        try profile_scope = container.decode(String.self, forKey: .profile_scope)
        try profile_source_type = container.decode(String.self, forKey: .profile_source_type)
    }
}

// MARK: - Encodable conformance
extension ESProfileAddEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(instigator_process_name, forKey: .instigator_process_name)
        try container.encode(instigator_process_path, forKey: .instigator_process_path)
        try container.encode(instigator_process_audit_token, forKey: .instigator_process_audit_token)
        try container.encode(instigator_process_signing_id, forKey: .instigator_process_signing_id)
        try container.encode(is_update, forKey: .is_update)
        try container.encode(profile_identifier, forKey: .profile_identifier)
        try container.encode(profile_organization, forKey: .profile_organization)
        try container.encode(profile_display_name, forKey: .profile_display_name)
        try container.encode(profile_scope, forKey: .profile_scope)
        try container.encode(profile_source_type, forKey: .profile_source_type)
    }
}
