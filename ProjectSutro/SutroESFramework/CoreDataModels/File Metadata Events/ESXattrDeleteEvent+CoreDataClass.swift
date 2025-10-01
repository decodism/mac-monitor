//
//  ESXattrDeleteEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 11/15/22.
//
//

import Foundation
import CoreData

@objc(ESXattrDeleteEvent)
public class ESXattrDeleteEvent: NSManagedObject , Decodable {
    enum CodingKeys: CodingKey {
        case id, target, extattr
    }
    
    // MARK: - Custom initilizer for ESXattrDeleteEvent during heavy flows
    convenience init(from message: Message) {
        let event: XattrDeleteEvent = message.event.deleteextattr!
        self.init()
        self.id = event.id
        
        target = ESFile(from: event.target)
        extattr = event.extattr
    }
    
    // MARK: - Custom Core Data initilizer for ESXattrDeleteEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let event: XattrDeleteEvent = message.event.deleteextattr!
        let description = NSEntityDescription.entity(forEntityName: "ESXattrDeleteEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = event.id
        
        target = ESFile(from: event.target, insertIntoManagedObjectContext: context)
        extattr = event.extattr
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try target = container.decode(ESFile.self, forKey: .target)
        try extattr = container.decode(String.self, forKey: .extattr)
    }
}

// MARK: - Encodable conformance
extension ESXattrDeleteEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(target, forKey: .target)
        try container.encode(extattr, forKey: .extattr)
    }
}
