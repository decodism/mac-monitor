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
        case id, file_name, file_path
    }
    
    
    convenience init(from message: Message) {
        let fileEvent: FileCloseEvent = message.event.close!
        self.init()
        self.id = fileEvent.id
        self.file_name = fileEvent.file_name!
        self.file_path = fileEvent.file_path!
    }
    
    // MARK: - Custom Core Data initilizer for RCESFileOpenEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let fileEvent: FileCloseEvent = message.event.close!
        let description = NSEntityDescription.entity(forEntityName: "ESFileCloseEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = fileEvent.id
        self.file_name = fileEvent.file_name!
        self.file_path = fileEvent.file_path!
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try file_path = container.decode(String.self, forKey: .file_path)
        try file_name = container.decode(String.self, forKey: .file_name)
    }
}

// MARK: - Encodable conformance
extension ESFileCloseEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(file_path, forKey: .file_path)
        try container.encode(file_name, forKey: .file_name)
    }
}
