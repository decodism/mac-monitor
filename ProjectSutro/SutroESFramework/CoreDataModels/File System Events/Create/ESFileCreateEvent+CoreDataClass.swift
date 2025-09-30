//
//  ESFileCreateEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 11/15/22.
//
//

import Foundation
import CoreData

@objc(ESFileCreateEvent)
public class ESFileCreateEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case destination_type
        case destination_type_string
        case destination
        case acl
        case is_quarantined
    }
    
    // MARK: - Custom initilizer for ESFileCreateEvent during heavy flows
    convenience init(from message: Message) {
        let create: FileCreateEvent = message.event.create!
        self.init()
        
        self.id = create.id
        self.destination_type = Int16(create.destination_type)
        self.destination_type_string = create.destination_type_string
        self.destination = ESFileDestination(from: create.destination)
        self.acl = create.acl
        self.is_quarantined = create.is_quarantined
    }
    
    // MARK: - Custom Core Data initilizer for ESFileCreateEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let create: FileCreateEvent = message.event.create!
        let description = NSEntityDescription.entity(forEntityName: "ESFileCreateEvent", in: context)!
        self.init(entity: description, insertInto: context)
        
        self.destination_type = Int16(create.destination_type)
        self.destination_type_string = create.destination_type_string
        self.destination = ESFileDestination(from: create.destination, insertIntoManagedObjectContext: context)
        self.acl = create.acl
        self.is_quarantined = create.is_quarantined
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try destination_type = container.decode(Int16.self, forKey: .destination_type)
        try destination_type_string = container.decode(String.self, forKey: .destination_type_string)
        try destination = container.decode(ESFileDestination.self, forKey: .destination)
        try acl = container.decodeIfPresent(String.self, forKey: .acl)
        try is_quarantined = container.decode(Int16.self, forKey: .is_quarantined)
    }
}

// MARK: - Encodable conformance
extension ESFileCreateEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
        
        try container.encode(destination_type, forKey: .destination_type)
        try container.encode(destination_type_string, forKey: .destination_type_string)
        try container.encode(destination, forKey: .destination)
        try container.encode(acl, forKey: .acl)
        try container.encode(is_quarantined, forKey: .is_quarantined)
    }
    
    public var targetPath: String {
        if let existingFile = destination.existing_file,
           let path = existingFile.path {
            return path
        } else if let newPath = destination.new_path {
            return newPath.path
        }
        
        return ""
    }
    
    public var fileName: String {
        return URL(string: targetPath)!.lastPathComponent
    }
}
