//
//  ESPTYGrantEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 9/29/25.
//
//

import Foundation
import CoreData


@objc(ESPTYGrantEvent)
public class ESPTYGrantEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case dev
    }
    
    // MARK: - Custom initilizer for ESPTYGrantEvent during heavy flows
    convenience init(from message: Message) {
        let event: PTYGrantEvent = message.event.pty_grant!
        self.init()
        self.id = event.id
        self.dev = event.dev
    }
    
    // MARK: - Custom Core Data initilizer for ESPTYGrantEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let event: PTYGrantEvent = message.event.pty_grant!
        let description = NSEntityDescription.entity(forEntityName: "ESPTYGrantEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = event.id
        self.dev = event.dev
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try dev = container.decode(Int64.self, forKey: .dev)
    }
}

// MARK: - Encodable conformance
extension ESPTYGrantEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dev, forKey: .dev)
    }
}
