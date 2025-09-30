//
//  ESFDDuplicateEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 2/16/23.
//
//

import Foundation
import CoreData

@objc(ESFDDuplicateEvent)
public class ESFDDuplicateEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case target
    }
    
    // MARK: - Custom initilizer for ESFDDuplicateEvent during heavy flows
    convenience init(from message: Message) {
        let event: FDDuplicateEvent = message.event.dup!
        self.init()
        self.id = event.id
        self.target = ESFile(from: event.target)
    }
    
    // MARK: - Custom Core Data initilizer for ESFDDuplicateEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let event: FDDuplicateEvent = message.event.dup!
        let description = NSEntityDescription.entity(forEntityName: "ESFDDuplicateEvent", in: context)!
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
extension ESFDDuplicateEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
        try container.encode(target, forKey: .target)
    }
}
