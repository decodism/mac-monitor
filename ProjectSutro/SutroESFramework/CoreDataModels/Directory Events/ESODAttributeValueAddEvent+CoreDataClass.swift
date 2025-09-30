//
//  ESODAttributeValueAddEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 6/28/23.
//
//

import Foundation
import CoreData


@objc(ESODAttributeValueAddEvent)
public class ESODAttributeValueAddEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, instigator_process_name, instigator_process_path, instigator_process_audit_token, instigator_process_signing_id, error_code, record_type, record_name, attribute_name, attribute_value, node_name, db_path, error_code_human
    }
    
    convenience init(from message: Message) {
        let attributeValueAddEvent: OpenDirectoryAttributeValueAddEvent = message.event.od_attribute_value_add!
        self.init()
        
        self.id = attributeValueAddEvent.id
        self.instigator_process_name = attributeValueAddEvent.instigator_process_name
        self.instigator_process_path = attributeValueAddEvent.instigator_process_path
        self.instigator_process_audit_token = attributeValueAddEvent.instigator_process_audit_token
        self.instigator_process_signing_id = attributeValueAddEvent.instigator_process_signing_id
        
        self.error_code = Int32(attributeValueAddEvent.error_code)
        self.record_type = attributeValueAddEvent.record_type
        self.record_name = attributeValueAddEvent.record_name
        self.attribute_name = attributeValueAddEvent.attribute_name
        self.attribute_value = attributeValueAddEvent.attribute_value
        self.node_name = attributeValueAddEvent.node_name
        self.db_path = attributeValueAddEvent.db_path
        self.error_code_human = attributeValueAddEvent.error_code_human
    }
    
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let attributeValueAddEvent: OpenDirectoryAttributeValueAddEvent = message.event.od_attribute_value_add!
        let description = NSEntityDescription.entity(forEntityName: "ESODAttributeValueAddEvent", in: context)!
        self.init(entity: description, insertInto: context)
        
        self.id = attributeValueAddEvent.id
        self.instigator_process_name = attributeValueAddEvent.instigator_process_name
        self.instigator_process_path = attributeValueAddEvent.instigator_process_path
        self.instigator_process_audit_token = attributeValueAddEvent.instigator_process_audit_token
        self.instigator_process_signing_id = attributeValueAddEvent.instigator_process_signing_id
        
        self.error_code = Int32(attributeValueAddEvent.error_code)
        self.record_type = attributeValueAddEvent.record_type
        self.record_name = attributeValueAddEvent.record_name
        self.attribute_name = attributeValueAddEvent.attribute_name
        self.attribute_value = attributeValueAddEvent.attribute_value
        self.node_name = attributeValueAddEvent.node_name
        self.db_path = attributeValueAddEvent.db_path
        self.error_code_human = attributeValueAddEvent.error_code_human
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
        try record_type = container.decode(String.self, forKey: .record_type)
        try record_name = container.decode(String.self, forKey: .record_name)
        try attribute_name = container.decode(String.self, forKey: .attribute_name)
        try attribute_value = container.decode(String.self, forKey: .attribute_value)
        try node_name = container.decode(String.self, forKey: .node_name)
        try db_path = container.decode(String.self, forKey: .db_path)
        try error_code_human = container.decode(String.self, forKey: .error_code_human)
    }
}

extension ESODAttributeValueAddEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(instigator_process_name, forKey: .instigator_process_name)
        try container.encode(instigator_process_path, forKey: .instigator_process_path)
        try container.encode(instigator_process_audit_token, forKey: .instigator_process_audit_token)
        try container.encode(instigator_process_signing_id, forKey: .instigator_process_signing_id)
        
        try container.encode(error_code, forKey: .error_code)
        try container.encode(record_type, forKey: .record_type)
        try container.encode(record_name, forKey: .record_name)
        try container.encode(attribute_name, forKey: .attribute_name)
        try container.encode(attribute_value, forKey: .attribute_value)
        try container.encode(node_name, forKey: .node_name)
        try container.encode(db_path, forKey: .db_path)
        try container.encode(error_code_human, forKey: .error_code_human)
    }
}
