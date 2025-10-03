//
//  ESMountEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/17/23.
//
//

import Foundation
import CoreData

@objc(ESMountEvent)
public class ESMountEvent: NSManagedObject {
    enum CodingKeys: CodingKey {
        case id
        case statfs
        case disposition
        case disposition_string
    }
    
    public var statfs: StatFS {
        get {
            let data = statfsData
            return try! JSONDecoder().decode(StatFS.self, from: data)
        }
        set {
            statfsData = try! JSONEncoder().encode(newValue)
        }
    }
    
    // MARK: - Custom Core Data initilizer for ESMountEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let event: MountEvent = message.event.mount!
        let description = NSEntityDescription.entity(forEntityName: "ESMountEvent", in: context)!
        self.init(entity: description, insertInto: context)
        
        self.id = event.id
        self.statfs = event.statfs
        self.disposition = event.disposition
        self.disposition_string = event.disposition_string
    }
}

// MARK: - Encodable conformance
extension ESMountEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
//        try container.encode(id, forKey: .id)
        try container.encode(statfs, forKey: .statfs)
        try container.encode(disposition, forKey: .disposition)
        try container.encode(disposition_string, forKey: .disposition_string)
    }
}
