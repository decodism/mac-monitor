//
//  ESFileWriteEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/1/23.
//
//

import Foundation
import CoreData


@objc(ESFileWriteEvent)
public class ESFileWriteEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case target
    }
    
    
    convenience init(from message: Message) {
        let event: FileWriteEvent = message.event.write!
        self.init()
        self.id = event.id
        
        self.target = ESFile(from: event.target)
    }
    
    // MARK: - Custom Core Data initilizer for ESFileWriteEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let event: FileWriteEvent = message.event.write!
        let description = NSEntityDescription.entity(forEntityName: "ESFileWriteEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = event.id
        
        self.target = ESFile(from: event.target, insertIntoManagedObjectContext: context)
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        
        try target = container.decode(ESFile.self, forKey: .target)
    }
}

// MARK: - Encodable conformance
extension ESFileWriteEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(target, forKey: .target)
    }
}
