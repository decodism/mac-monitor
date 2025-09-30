//
//  ESXProtectDetect+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 12/30/22.
//
//

import Foundation
import CoreData

@objc(ESXProtectDetect)
public class ESXProtectDetect: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case signature_version
        case malware_identifier
        case incident_identifier
        case detected_path
        case detected_executable
    }

    // MARK: - Custom initilizer for ESXProtectDetect during heavy flows
    convenience init(from message: Message) {
        let xprotectDetectItem: XProtectDetectEvent = message.event.xp_malware_detected!
        self.init()
        self.id = xprotectDetectItem.id
        
        self.signature_version = xprotectDetectItem.signature_version
        self.malware_identifier = xprotectDetectItem.malware_identifier
        self.incident_identifier = xprotectDetectItem.incident_identifier
        self.detected_path = xprotectDetectItem.detected_path
        
        self.detected_executable = xprotectDetectItem.detected_executable
    }
    
    // MARK: - Custom Core Data initilizer for ESXProtectDetect
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let xprotectDetectItem: XProtectDetectEvent = message.event.xp_malware_detected!
        let description = NSEntityDescription.entity(forEntityName: "ESXProtectDetect", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = xprotectDetectItem.id
        
        self.signature_version = xprotectDetectItem.signature_version
        self.malware_identifier = xprotectDetectItem.malware_identifier
        self.incident_identifier = xprotectDetectItem.incident_identifier
        self.detected_path = xprotectDetectItem.detected_path
        
        self.detected_executable = xprotectDetectItem.detected_executable
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try signature_version = container.decode(String.self, forKey: .signature_version)
        try malware_identifier = container.decode(String.self, forKey: .malware_identifier)
        try incident_identifier = container.decode(String.self, forKey: .incident_identifier)
        try detected_path = container.decode(String.self, forKey: .detected_path)
        
        try detected_executable = container.decodeIfPresent(String.self, forKey: .detected_executable)
    }
}

// MARK: - Encodable conformance
extension ESXProtectDetect: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
        try container.encode(signature_version, forKey: .signature_version)
        try container.encode(malware_identifier, forKey: .malware_identifier)
        try container.encode(incident_identifier, forKey: .incident_identifier)
        try container.encode(detected_path, forKey: .detected_path)
        
        try container.encodeIfPresent(detected_executable, forKey: .detected_executable)
    }
}
