//
//  ESFileDeleteEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/1/23.
//
//

import Foundation
import CoreData

@objc(ESFileDeleteEvent)
public class ESFileDeleteEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, file_name, file_path, parent_directory
    }
    
    
    convenience init(from message: Message) {
        let fileEvent: FileDeleteEvent = message.event.unlink!
        self.init()
        self.id = fileEvent.id
        self.file_name = fileEvent.file_name!
        self.file_path = fileEvent.file_path!
        self.parent_directory = fileEvent.parent_directory!
    }
    
    // MARK: - Custom Core Data initilizer for ESFileDeleteEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let fileEvent: FileDeleteEvent = message.event.unlink!
        let description = NSEntityDescription.entity(forEntityName: "ESFileDeleteEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = fileEvent.id
        self.file_name = fileEvent.file_name!
        self.file_path = fileEvent.file_path!
        self.parent_directory = fileEvent.parent_directory!
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try file_path = container.decode(String.self, forKey: .file_path)
        try file_name = container.decode(String.self, forKey: .file_name)
        try parent_directory = container.decode(String.self, forKey: .parent_directory)
    }
}

// MARK: - Encodable conformance
extension ESFileDeleteEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(file_path, forKey: .file_path)
        try container.encode(file_name, forKey: .file_name)
        try container.encode(parent_directory, forKey: .parent_directory)
    }
}
