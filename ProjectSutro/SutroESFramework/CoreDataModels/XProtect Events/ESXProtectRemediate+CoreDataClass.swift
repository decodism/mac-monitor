//
//  ESXProtectRemediate+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 12/30/22.
//
//

import Foundation
import CoreData

@objc(ESXProtectRemediate)
public class ESXProtectRemediate: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case signature_version
        case malware_identifier
        case incident_identifier
        case action_type
        case success
        case result_description
        case remediated_path
        case remediated_process_audit_token
    }
    
    // MARK: - Custom initilizer for ESXProtectRemediate during heavy flows
    convenience init(from message: Message) {
        let xprotectRemediateItem: XProtecRemediateEvent = message.event.xp_malware_remediated!
        self.init()
        self.id = xprotectRemediateItem.id
        
        self.signature_version = xprotectRemediateItem.signature_version
        self.malware_identifier = xprotectRemediateItem.malware_identifier
        self.incident_identifier = xprotectRemediateItem.incident_identifier
        self.action_type = xprotectRemediateItem.action_type
        self.success = xprotectRemediateItem.success
        self.result_description = xprotectRemediateItem.result_description
        self.remediated_path = xprotectRemediateItem.remediated_path
        if let token = xprotectRemediateItem.remediated_process_audit_token {
            self.remediated_process_audit_token = ESAuditToken(from: token)
        }
    }
    
    // MARK: - Custom Core Data initilizer for ESXProtectRemediate
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let xprotectRemediateItem: XProtecRemediateEvent = message.event.xp_malware_remediated!
        let description = NSEntityDescription.entity(forEntityName: "ESXProtectRemediate", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = xprotectRemediateItem.id
        
        self.signature_version = xprotectRemediateItem.signature_version
        self.malware_identifier = xprotectRemediateItem.malware_identifier
        self.incident_identifier = xprotectRemediateItem.incident_identifier
        self.action_type = xprotectRemediateItem.action_type
        self.success = xprotectRemediateItem.success
        self.result_description = xprotectRemediateItem.result_description
        self.remediated_path = xprotectRemediateItem.remediated_path
        if let token = xprotectRemediateItem.remediated_process_audit_token {
            self.remediated_process_audit_token = ESAuditToken(from: token, insertIntoManagedObjectContext: context)
        }
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try signature_version = container.decode(String.self, forKey: .signature_version)
        try malware_identifier = container.decode(String.self, forKey: .malware_identifier)
        try incident_identifier = container.decode(String.self, forKey: .incident_identifier)
        try action_type = container.decode(String.self, forKey: .action_type)
        try success = container.decode(Bool.self, forKey: .success)
        try result_description = container.decode(String.self, forKey: .result_description)
        try remediated_path = container.decode(String.self, forKey: .remediated_path)
        try remediated_process_audit_token = container.decodeIfPresent(ESAuditToken.self, forKey: .remediated_process_audit_token)
    }
}

// MARK: - Encodable conformance
extension ESXProtectRemediate: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
        try container.encode(signature_version, forKey: .signature_version)
        try container.encode(malware_identifier, forKey: .malware_identifier)
        try container.encode(incident_identifier, forKey: .incident_identifier)
        try container.encode(action_type, forKey: .action_type)
        try container.encode(success, forKey: .success)
        try container.encode(result_description, forKey: .result_description)
        try container.encode(remediated_path, forKey: .remediated_path)
        try container.encodeIfPresent(remediated_process_audit_token, forKey: .remediated_process_audit_token)
    }
}
