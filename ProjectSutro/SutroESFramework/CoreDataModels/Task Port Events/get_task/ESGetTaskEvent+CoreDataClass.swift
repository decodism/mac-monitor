//
//  ESGetTaskEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/3/23.
//
//

import Foundation
import CoreData

@objc(ESGetTaskEvent)
public class ESGetTaskEvent: NSManagedObject, Decodable {
    
    enum CodingKeys: CodingKey {
        case id
        case target
        case type
        case type_string
    }
    
    // MARK: - Custom initilizer for ESGetTaskEvent during heavy flows
    convenience init(from message: Message) {
        let event: GetTaskEvent = message.event.get_task!
        self.init()
        self.id = event.id

        self.target = ESProcess(from: event.target, version: message.version)
        self.type = event.type
        self.type_string = event.type_string
    }
    
    // MARK: - Custom Core Data initilizer for ESGetTaskEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let event: GetTaskEvent = message.event.get_task!
        let description = NSEntityDescription.entity(forEntityName: "ESGetTaskEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = event.id

        self.target = ESProcess(
            from: event.target,
            version: message.version,
            insertIntoManagedObjectContext: context
        )
        self.type = event.type
        self.type_string = event.type_string
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try target = container.decode(ESProcess.self, forKey: .target)
        try type = container.decode(Int16.self, forKey: .type)
        try type_string = container.decode(String.self, forKey: .type_string)
    }
}

// MARK: - Encodable conformance
extension ESGetTaskEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(target, forKey: .target)
        try container.encode(type, forKey: .type)
        try container.encode(type_string, forKey: .type_string)
    }
}

