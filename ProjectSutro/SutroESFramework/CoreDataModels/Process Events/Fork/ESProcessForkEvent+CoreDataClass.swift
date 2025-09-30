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
public class ESProcessForkEvent: NSManagedObject, Decodable {
    
    enum CodingKeys: CodingKey {
        case id, child
    }
    
    // MARK: - Custom initilizer for ESProcessForkEvent during heavy flows
    convenience init(from message: Message) {
        let forkEvent: ProcessForkEvent = message.event.fork!
        self.init()
        self.id = forkEvent.id
        
        self.child = ESProcess(from: forkEvent.child, version: message.version)
    }
    
    // MARK: - Custom Core Data initilizer for ESProcessForkEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let forkEvent: ProcessForkEvent = message.event.fork!
        let description = NSEntityDescription.entity(forEntityName: "ESProcessForkEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = forkEvent.id
        
        self.child = ESProcess(from: forkEvent.child, version: message.version, insertIntoManagedObjectContext: context)
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try child = container.decode(ESProcess.self, forKey: .child)
    }
}

// MARK: - Encodable conformance
extension ESProcessForkEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(child, forKey: .child)
    }
}
