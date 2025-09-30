//
//  ESFDDuplicateEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 2/16/23.
//
//

import Foundation
import CoreData

@objc(ESFDDuplicateEvent)
public class ESFDDuplicateEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, file_name, file_path, is_quarantined
    }
    
    // MARK: - Custom initilizer for ESFDDuplicateEvent during heavy flows
    convenience init(from message: Message) {
        let fileEvent: FDDuplicateEvent = message.event.dup!
        self.init()
        self.id = fileEvent.id
        self.file_name = fileEvent.file_name!
        self.file_path = fileEvent.file_path!
//        self.is_quarantined = fileEvent.is_quarantined
    }
    
    // MARK: - Custom Core Data initilizer for ESFDDuplicateEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let fileEvent: FDDuplicateEvent = message.event.dup!
        let description = NSEntityDescription.entity(forEntityName: "ESFDDuplicateEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = fileEvent.id
        self.file_name = fileEvent.file_name!
        self.file_path = fileEvent.file_path!
//        self.is_quarantined = fileEvent.is_quarantined
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try file_path = container.decode(String.self, forKey: .file_path)
        try file_name = container.decode(String.self, forKey: .file_name)
//        try is_quarantined = container.decode(Bool.self, forKey: .is_quarantined)
    }
}

// MARK: - Encodable conformance
extension ESFDDuplicateEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
        try container.encode(file_path, forKey: .file_path)
        try container.encode(file_name, forKey: .file_name)
//        try container.encode(is_quarantined, forKey: .is_quarantined)
    }
}
