//
//  ESProcessSignalEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/2/23.
//
//

import Foundation
import CoreData

@objc(ESProcessSignalEvent)
public class ESProcessSignalEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case sig
        case signal_name
        case target
        case instigator
    }
    
    // MARK: - Custom initilizer for ESProcessSignalEvent during heavy flows
    convenience init(from message: Message) {
        let signalEvent: ProcessSignalEvent = message.event.signal!
        self.init()
        self.id = signalEvent.id
        self.sig = Int32(signalEvent.sig)
        self.signal_name = signalEvent.signal_name
        
        /// Process structures
        self.target = ESProcess(from: signalEvent.target, version: message.version)
        if let instigator = signalEvent.instigator {
            self.instigator = ESProcess(from: instigator, version: message.version)
        }
    }
    
    // MARK: - Custom Core Data initilizer for ESProcessSignalEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let signalEvent: ProcessSignalEvent = message.event.signal!
        let description = NSEntityDescription.entity(forEntityName: "ESProcessSignalEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = signalEvent.id
        self.sig = Int32(signalEvent.sig)
        self.signal_name = signalEvent.signal_name
        
        /// Process structures
        self.target = ESProcess(from: signalEvent.target, version: message.version, insertIntoManagedObjectContext: context)
        if let instigator = signalEvent.instigator {
            self.instigator = ESProcess(from: instigator, version: message.version, insertIntoManagedObjectContext: context)
        }
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try sig = container.decode(Int32.self, forKey: .sig)
        try signal_name = container.decode(String.self, forKey: .signal_name)
        
        try target = container.decode(ESProcess.self, forKey: .target)
        try instigator = container.decodeIfPresent(ESProcess.self, forKey: .instigator)
    }
}

// MARK: - Encodable conformance
extension ESProcessSignalEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sig, forKey: .sig)
        try container.encode(signal_name, forKey: .signal_name)
        
        try container.encode(target, forKey: .target)
        try container.encode(instigator, forKey: .instigator)
    }
}
