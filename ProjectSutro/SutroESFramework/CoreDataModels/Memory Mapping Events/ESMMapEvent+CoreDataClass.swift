//
//  ESMMapEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 11/15/22.
//
//

import Foundation
import CoreData

@objc(ESMMapEvent)
public class ESMMapEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case protection
        case max_protection
        case flags
        case file_pos
        case source
    }
    
    // MARK: - Custom initilizer for ESMMapEvent during heavy flows
    convenience init(from message: Message) {
        let mmapEvent: MMapEvent = message.event.mmap!
        self.init()
        self.id = mmapEvent.id
        
        self.protection = mmapEvent.protection
        self.max_protection = mmapEvent.max_protection
        self.flags = mmapEvent.flags
        self.file_pos = Int64(mmapEvent.file_pos)
        self.source = ESFile(from: mmapEvent.source)
    }
    
    // MARK: - Custom Core Data initilizer for ESMMapEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let mmapEvent: MMapEvent = message.event.mmap!
        let description = NSEntityDescription.entity(forEntityName: "ESMMapEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = mmapEvent.id
        
        self.protection = mmapEvent.protection
        self.max_protection = mmapEvent.max_protection
        self.flags = mmapEvent.flags
        self.file_pos = Int64(mmapEvent.file_pos)
        self.source = ESFile(
            from: mmapEvent.source,
            insertIntoManagedObjectContext: context
        )
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        try id = container.decode(UUID.self, forKey: .id)
        
        try protection = container.decode(Int32.self, forKey: .protection)
        try max_protection = container.decode(Int32.self, forKey: .max_protection)
        try flags = container.decode(Int32.self, forKey: .flags)
        try file_pos = container.decode(Int64.self, forKey: .file_pos)
        try source = container.decodeIfPresent(ESFile.self, forKey: .source)!
    }
}

// MARK: - Encodable conformance
extension ESMMapEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(protection, forKey: .protection)
        try container.encode(max_protection, forKey: .max_protection)
        try container.encode(flags, forKey: .flags)
        try container.encode(file_pos, forKey: .file_pos)
        try container.encode(source, forKey: .source)
    }
}
