//
//  ESProcessExitEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 11/15/22.
//
//

import Foundation
import CoreData
import OSLog

@objc(ESProcessExitEvent)
public class ESProcessExitEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, stat
    }
    
    // MARK: - Custom initilizer for ESProcessExitEvent during heavy flows
    convenience init(from message: Message) {
        let exitEvent: ProcessExitEvent = message.event.exit!
        self.init()
        self.id = exitEvent.id
        self.stat = Int32(exitEvent.stat)
    }
    
    // MARK: - Custom Core Data initilizer for ESProcessExitEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let exitEvent: ProcessExitEvent = message.event.exit!
        let description = NSEntityDescription.entity(forEntityName: "ESProcessExitEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = exitEvent.id
        self.stat = Int32(exitEvent.stat)
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try stat = container.decode(Int32.self, forKey: .stat)
    }
}

// MARK: - Encodable conformance
extension ESProcessExitEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
        try container.encode(stat, forKey: .stat)
    }
}
