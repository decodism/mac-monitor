//
//  ESODCreateGroupEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 6/28/23.
//
//

import Foundation
import CoreData


@objc(ESODCreateGroupEvent)
public class ESODCreateGroupEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, instigator_process_name, instigator_process_path, instigator_process_audit_token, instigator_process_signing_id, error_code, group_name, node_name, db_path, error_code_human
    }
    
    convenience init(from message: Message) {
        let odCreateGroupEvent: OpenDirectoryCreateGroupEvent = message.event.od_create_group!
        self.init()
        
        self.id = odCreateGroupEvent.id
        self.instigator_process_name = odCreateGroupEvent.instigator_process_name
        self.instigator_process_path = odCreateGroupEvent.instigator_process_path
        self.instigator_process_audit_token = odCreateGroupEvent.instigator_process_audit_token
        self.instigator_process_signing_id = odCreateGroupEvent.instigator_process_signing_id
        
        self.error_code = Int32(odCreateGroupEvent.error_code)
        self.group_name = odCreateGroupEvent.group_name
        self.node_name = odCreateGroupEvent.node_name
        self.db_path = odCreateGroupEvent.db_path
        self.error_code_human = odCreateGroupEvent.error_code_human
    }
    
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let odCreateGroupEvent: OpenDirectoryCreateGroupEvent = message.event.od_create_group!
        let description = NSEntityDescription.entity(forEntityName: "ESODCreateGroupEvent", in: context)!
        self.init(entity: description, insertInto: context)
        
        self.id = odCreateGroupEvent.id
        self.instigator_process_name = odCreateGroupEvent.instigator_process_name
        self.instigator_process_path = odCreateGroupEvent.instigator_process_path
        self.instigator_process_audit_token = odCreateGroupEvent.instigator_process_audit_token
        self.instigator_process_signing_id = odCreateGroupEvent.instigator_process_signing_id
        
        self.error_code = Int32(odCreateGroupEvent.error_code)
        self.group_name = odCreateGroupEvent.group_name
        self.node_name = odCreateGroupEvent.node_name
        self.db_path = odCreateGroupEvent.db_path
        self.error_code_human = odCreateGroupEvent.error_code_human
    }
    
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try instigator_process_name = container.decode(String.self, forKey: .instigator_process_name)
        try instigator_process_path = container.decode(String.self, forKey: .instigator_process_path)
        try instigator_process_audit_token = container.decode(String.self, forKey: .instigator_process_audit_token)
        try instigator_process_signing_id = container.decode(String.self, forKey: .instigator_process_signing_id)
        
        try error_code = container.decode(Int32.self, forKey: .error_code)
        try group_name = container.decode(String.self, forKey: .group_name)
        try node_name = container.decode(String.self, forKey: .node_name)
        try db_path = container.decode(String.self, forKey: .db_path)
        try error_code_human = container.decode(String.self, forKey: .error_code_human)
    }
}

extension ESODCreateGroupEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(instigator_process_name, forKey: .instigator_process_name)
        try container.encode(instigator_process_path, forKey: .instigator_process_path)
        try container.encode(instigator_process_audit_token, forKey: .instigator_process_audit_token)
        try container.encode(instigator_process_signing_id, forKey: .instigator_process_signing_id)
        
        try container.encode(error_code, forKey: .error_code)
        try container.encode(group_name, forKey: .group_name)
        try container.encode(node_name, forKey: .node_name)
        try container.encode(db_path, forKey: .db_path)
        try container.encode(error_code_human, forKey: .error_code_human)
    }
}
