//
//  ESProcessForkEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 11/15/22.
//
//

import Foundation
import CoreData

@objc(ESProcessForkEvent)
public class ESProcessForkEvent: NSManagedObject {
    
    enum CodingKeys: CodingKey {
        case id, child
    }
    
    // MARK: - Custom Core Data initilizer for ESProcessForkEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let forkEvent: ProcessForkEvent = message.event.fork!
        let description = NSEntityDescription.entity(forEntityName: "ESProcessForkEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = forkEvent.id
        
        self.child = ESProcess(from: forkEvent.child, version: message.version, insertIntoManagedObjectContext: context)
    }
}

// MARK: - Encodable conformance
extension ESProcessForkEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(child, forKey: .child)
    }
}
