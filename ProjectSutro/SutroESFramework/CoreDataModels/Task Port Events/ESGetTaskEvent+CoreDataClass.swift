//
//  ESGetTaskEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/3/23.
//
//

import Foundation
import CoreData

@objc(ESGetTaskEvent)
public class ESGetTaskEvent: NSManagedObject, Decodable {
    
    enum CodingKeys: CodingKey {
        case id, process_name, process_path, audit_token, signing_id, type
    }
    
    // MARK: - Custom initilizer for ESGetTaskEvent during heavy flows
    convenience init(from message: Message) {
        let getTaskEvent: GetTaskEvent = message.event.get_task!
        self.init()
        self.id = getTaskEvent.id

        self.process_audit_token = getTaskEvent.audit_token!
        self.process_name = getTaskEvent.process_name!
        self.process_path = getTaskEvent.process_path!
        self.process_signing_id = getTaskEvent.signing_id!
        self.type = getTaskEvent.type!
    }
    
    // MARK: - Custom Core Data initilizer for ESGetTaskEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let getTaskEvent: GetTaskEvent = message.event.get_task!
        let description = NSEntityDescription.entity(forEntityName: "ESGetTaskEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = getTaskEvent.id

        self.process_audit_token = getTaskEvent.audit_token!
        self.process_name = getTaskEvent.process_name!
        self.process_path = getTaskEvent.process_path!
        self.process_signing_id = getTaskEvent.signing_id!
        self.type = getTaskEvent.type!
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try process_audit_token = container.decode(String.self, forKey: .audit_token)
        try process_signing_id = container.decode(String.self, forKey: .signing_id)
        try process_name = container.decode(String.self, forKey: .process_name)
        try process_path = container.decode(String.self, forKey: .process_path)
        try type = container.decode(String.self, forKey: .type)
    }
}

// MARK: - Encodable conformance
extension ESGetTaskEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(process_audit_token, forKey: .audit_token)
        try container.encode(process_name, forKey: .process_name)
        try container.encode(process_path, forKey: .process_path)
        try container.encode(process_signing_id, forKey: .signing_id)
        try container.encode(type, forKey: .type)
    }
}

