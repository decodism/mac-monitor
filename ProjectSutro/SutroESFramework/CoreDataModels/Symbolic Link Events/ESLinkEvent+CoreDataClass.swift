//
//  ESLinkEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/1/23.
//
//

import Foundation
import CoreData

@objc(ESLinkEvent)
public class ESLinkEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, source_file_name, source_file_path, target_file_name, target_file_path
    }
    
    
    convenience init(from message: Message) {
        let linkEvent: LinkEvent = message.event.link!
        self.init()
        self.id = linkEvent.id
        self.source_file_name = linkEvent.source_file_name!
        self.source_file_path = linkEvent.source_file_path!
        self.target_file_name = linkEvent.target_file_name!
        self.target_file_path = linkEvent.target_file_path!
    }
    
    // MARK: - Custom Core Data initilizer for ESLinkEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let linkEvent: LinkEvent = message.event.link!
        let description = NSEntityDescription.entity(forEntityName: "ESLinkEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = linkEvent.id
        self.source_file_name = linkEvent.source_file_name!
        self.source_file_path = linkEvent.source_file_path!
        self.target_file_name = linkEvent.target_file_name!
        self.target_file_path = linkEvent.target_file_path!
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try source_file_name = container.decode(String.self, forKey: .source_file_name)
        try source_file_path = container.decode(String.self, forKey: .source_file_path)
        try target_file_name = container.decode(String.self, forKey: .target_file_name)
        try target_file_path = container.decode(String.self, forKey: .target_file_path)
    }
}

// MARK: - Encodable conformance
extension ESLinkEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(source_file_name, forKey: .source_file_name)
        try container.encode(source_file_path, forKey: .source_file_path)
        try container.encode(target_file_name, forKey: .target_file_name)
        try container.encode(target_file_path, forKey: .target_file_path)
    }
}
