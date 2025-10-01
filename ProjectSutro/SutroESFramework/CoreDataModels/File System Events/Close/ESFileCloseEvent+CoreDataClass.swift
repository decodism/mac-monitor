//
//  ESFileCloseEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/2/23.
//
//

import Foundation
import CoreData

@objc(ESFileCloseEvent)
public class ESFileCloseEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case target
        case modified
        case was_mapped_writable
    }
    
    
    convenience init(from message: Message) {
        let event: FileCloseEvent = message.event.close!
        self.init()
        self.id = event.id
        self.target = ESFile(from: event.target)
        self.modified = event.modified
        self.was_mapped_writable = event.was_mapped_writable ?? false
    }
    
    // MARK: - Custom Core Data initilizer for ESFileCloseEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let event: FileCloseEvent = message.event.close!
        let description = NSEntityDescription.entity(forEntityName: "ESFileCloseEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = event.id
        
        self.target = ESFile(
            from: event.target,
            insertIntoManagedObjectContext: context
        )
        self.modified = event.modified
        self.was_mapped_writable = event.was_mapped_writable ?? false
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try target = container.decode(ESFile.self, forKey: .target)
        try modified = container.decode(Bool.self, forKey: .modified)
        try was_mapped_writable = container
            .decode(Bool.self, forKey: .was_mapped_writable)
    }
}

// MARK: - Encodable conformance
extension ESFileCloseEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(target, forKey: .target)
        try container.encode(modified, forKey: .modified)
        try container
            .encodeIfPresent(was_mapped_writable, forKey: .was_mapped_writable)
    }
}
