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
public class ESAuthorizationPetitionEvent: NSManagedObject {
    enum CodingKeys: CodingKey {
        case id
        case instigator
        case petitioner
        case flags
        case flags_array
        case right_count
        case rights
        case instigator_token
        case petitioner_token
    }
    
    
    public var flags_array: [String] {
        get {
            guard let data = flagsData else { return [] }
            return (try? JSONDecoder().decode([String].self, from: data)) ?? []
        }
        set {
            flagsData = try? JSONEncoder().encode(newValue)
        }
    }
    
    public var rights: [String] {
        get {
            guard let data = rightsData else { return [] }
            return (try? JSONDecoder().decode([String].self, from: data)) ?? []
        }
        set {
            rightsData = try? JSONEncoder().encode(newValue)
        }
    }
    
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let event: AuthorizationPetitionEvent = message.event.authorization_petition!
        let description = NSEntityDescription.entity(forEntityName: "ESAuthorizationPetitionEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = event.id
        
        if let instigator = event.instigator,
           let instigator_token = event.instigator_token {
            self.instigator = ESProcess(
                from: instigator,
                version: message.version,
                insertIntoManagedObjectContext: context
            )
            
            self.instigator_token = ESAuditToken(
                from: instigator_token,
                insertIntoManagedObjectContext: context
            )
        }
        
        if let petitioner = event.petitioner,
           let petitioner_token = event.petitioner_token {
            self.petitioner = ESProcess(
                from: petitioner,
                version: message.version,
                insertIntoManagedObjectContext: context
            )
            
            self.petitioner_token = ESAuditToken(
                from: petitioner_token,
                insertIntoManagedObjectContext: context
            )
        }
        
        self.flags = event.flags
        self.flags_array = event.flags_array
        self.rights = event.rights
    }
}

extension ESAuthorizationPetitionEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(instigator, forKey: .instigator)
        try container.encode(petitioner, forKey: .petitioner)
        try container.encode(flags_array, forKey: .flags_array)
        try container.encode(flags, forKey: .flags)
        try container.encode(right_count, forKey: .right_count)
        try container.encode(rights, forKey: .rights)
        try container.encode(instigator_token, forKey: .instigator_token)
        try container.encode(petitioner_token, forKey: .petitioner_token)
    }
}
