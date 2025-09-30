//
//  ESCodeSignatureInvalidatedEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/3/23.
//
//

import Foundation
import CoreData

@objc(ESCodeSignatureInvalidatedEvent)
public class ESCodeSignatureInvalidatedEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
    }
    
    // MARK: - Custom initilizer for ESCodeSignatureInvalidatedEvent during heavy flows
    convenience init(from message: Message) {
        let csInvalidated: CodeSignatureInvalidatedEvent = message.event.cs_invalidated!
        self.init()
        
        self.id = csInvalidated.id
    }
    
    // MARK: - Custom Core Data initilizer for ESCodeSignatureInvalidatedEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let csInvalidated: CodeSignatureInvalidatedEvent = message.event.cs_invalidated!
        let description = NSEntityDescription.entity(forEntityName: "ESCodeSignatureInvalidatedEvent", in: context)!
        self.init(entity: description, insertInto: context)
        
        self.id = csInvalidated.id
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
    }
}

// MARK: - Encodable conformance
extension ESCodeSignatureInvalidatedEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        _ = encoder.container(keyedBy: CodingKeys.self)
    }
}
