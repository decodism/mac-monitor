//
//  ESSetModeEvent+CoreDataClass.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 9/29/25.
//
//

import Foundation
import CoreData


@objc(ESSetModeEvent)
public class ESSetModeEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case mode
        case target
    }
    
    // MARK: - Custom initilizer for ESSetModeEvent during heavy flows
    convenience init(from message: Message) {
        let event: SetModeEvent = message.event.setmode!
        self.init()
        self.id = event.id
        self.mode = event.mode
        self.target = ESFile(from: event.target)
    }
    
    // MARK: - Custom Core Data initilizer for ESSetModeEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let event: SetModeEvent = message.event.setmode!
        let description = NSEntityDescription.entity(forEntityName: "ESSetModeEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = event.id
        self.mode = event.mode
        self.target = ESFile(from: event.target, insertIntoManagedObjectContext: context)
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try mode = container.decode(Int32.self, forKey: .mode)
        try target = container.decode(ESFile.self, forKey: .target)
    }
}

// MARK: - Encodable conformance
extension ESSetModeEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mode, forKey: .mode)
        try container.encode(target, forKey: .target)
    }
}
