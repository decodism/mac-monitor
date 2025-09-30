//
//  ESAuthorizationPetitionEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 6/27/23.
//
//

import Foundation
import CoreData

@objc(ESAuthorizationPetitionEvent)
public class ESAuthorizationPetitionEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, instigator_process_name, instigator_process_path, instigator_process_audit_token, instigator_process_signing_id, petitioner_process_name, petitioner_process_path, petitioner_process_audit_token, petitioner_process_signing_id, flags, right_count, rights
    }
    
    convenience init(from message: Message) {
        let authorizationPetitionEvent: AuthorizationPetitionEvent = message.event.authorization_petition!
        self.init()
        
        self.id = authorizationPetitionEvent.id
        self.instigator_process_name = authorizationPetitionEvent.instigator_process_name
        self.instigator_process_path = authorizationPetitionEvent.instigator_process_path
        self.instigator_process_audit_token = authorizationPetitionEvent.instigator_process_audit_token
        self.instigator_process_signing_id = authorizationPetitionEvent.instigator_process_signing_id
        self.petitioner_process_name = authorizationPetitionEvent.petitioner_process_name
        self.petitioner_process_path = authorizationPetitionEvent.petitioner_process_path
        self.petitioner_process_audit_token = authorizationPetitionEvent.petitioner_process_audit_token
        self.petitioner_process_signing_id = authorizationPetitionEvent.petitioner_process_signing_id
        self.flags = authorizationPetitionEvent.flags
        self.right_count = Int32(authorizationPetitionEvent.right_count)
        self.rights = authorizationPetitionEvent.rights
    }
    
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let authorizationPetitionEvent: AuthorizationPetitionEvent = message.event.authorization_petition!
        let description = NSEntityDescription.entity(forEntityName: "ESAuthorizationPetitionEvent", in: context)!
        self.init(entity: description, insertInto: context)
        
        self.id = authorizationPetitionEvent.id
        self.instigator_process_name = authorizationPetitionEvent.instigator_process_name
        self.instigator_process_path = authorizationPetitionEvent.instigator_process_path
        self.instigator_process_audit_token = authorizationPetitionEvent.instigator_process_audit_token
        self.instigator_process_signing_id = authorizationPetitionEvent.instigator_process_signing_id
        self.petitioner_process_name = authorizationPetitionEvent.petitioner_process_name
        self.petitioner_process_path = authorizationPetitionEvent.petitioner_process_path
        self.petitioner_process_audit_token = authorizationPetitionEvent.petitioner_process_audit_token
        self.petitioner_process_signing_id = authorizationPetitionEvent.petitioner_process_signing_id
        self.flags = authorizationPetitionEvent.flags
        self.right_count = Int32(authorizationPetitionEvent.right_count)
        self.rights = authorizationPetitionEvent.rights
    }
    
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try instigator_process_name = container.decode(String.self, forKey: .instigator_process_name)
        try instigator_process_path = container.decode(String.self, forKey: .instigator_process_path)
        try instigator_process_audit_token = container.decode(String.self, forKey: .instigator_process_audit_token)
        try instigator_process_signing_id = container.decode(String.self, forKey: .instigator_process_signing_id)
        try petitioner_process_name = container.decode(String.self, forKey: .petitioner_process_name)
        try petitioner_process_path = container.decode(String.self, forKey: .petitioner_process_path)
        try petitioner_process_audit_token = container.decode(String.self, forKey: .petitioner_process_audit_token)
        try petitioner_process_signing_id = container.decode(String.self, forKey: .petitioner_process_signing_id)
        try flags = container.decode(String.self, forKey: .flags)
        try right_count = container.decode(Int32.self, forKey: .right_count)
        try rights = container.decode(String.self, forKey: .rights)
    }
}

extension ESAuthorizationPetitionEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(instigator_process_name, forKey: .instigator_process_name)
        try container.encode(instigator_process_path, forKey: .instigator_process_path)
        try container.encode(instigator_process_audit_token, forKey: .instigator_process_audit_token)
        try container.encode(instigator_process_signing_id, forKey: .instigator_process_signing_id)
        try container.encode(petitioner_process_name, forKey: .petitioner_process_name)
        try container.encode(petitioner_process_path, forKey: .petitioner_process_path)
        try container.encode(petitioner_process_audit_token, forKey: .petitioner_process_audit_token)
        try container.encode(petitioner_process_signing_id, forKey: .petitioner_process_signing_id)
        try container.encode(flags, forKey: .flags)
        try container.encode(right_count, forKey: .right_count)
        try container.encode(rights, forKey: .rights)
    }
}
