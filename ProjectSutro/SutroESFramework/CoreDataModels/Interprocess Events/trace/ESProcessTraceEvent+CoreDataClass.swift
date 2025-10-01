//
//  ESProcessTraceEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/3/23.
//
//

import Foundation
import CoreData

@objc(ESProcessTraceEvent)
public class ESProcessTraceEvent: NSManagedObject, Decodable {
    
    enum CodingKeys: CodingKey {
        case id
        case target
    }
    
    // MARK: - Custom initilizer for ESProcessTraceEvent during heavy flows
    convenience init(from message: Message) {
        let traceEvent: ProcessTraceEvent = message.event.trace!
        self.init()
        self.id = traceEvent.id

        self.target = ESProcess(from: traceEvent.target, version: message.version)
    }
    
    // MARK: - Custom Core Data initilizer for ESProcessTraceEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let traceEvent: ProcessTraceEvent = message.event.trace!
        let description = NSEntityDescription.entity(forEntityName: "ESProcessTraceEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = traceEvent.id

        self.target = ESProcess(from: traceEvent.target, version: message.version, insertIntoManagedObjectContext: context)
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try target = container.decode(ESProcess.self, forKey: .target)
    }
}

// MARK: - Encodable conformance
extension ESProcessTraceEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(target, forKey: .target)
    }
}
