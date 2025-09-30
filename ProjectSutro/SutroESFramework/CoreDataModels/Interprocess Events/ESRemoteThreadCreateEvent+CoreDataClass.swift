//
//  ESRemoteThreadCreateEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/2/23.
//
//

import Foundation
import CoreData

@objc(ESRemoteThreadCreateEvent)
public class ESRemoteThreadCreateEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case target
        case thread_state
    }
    
    // MARK: - Custom initilizer for ESRemoteThreadCreateEvent during heavy flows
    convenience init(from message: Message) {
        let threadEvent: RemoteThreadCreateEvent = message.event.remote_thread_create!
        self.init()
        self.id = threadEvent.id
        self.thread_state = threadEvent.thread_state
        self.target = ESProcess(from: threadEvent.target, version: message.version)
    }
    
    // MARK: - Custom Core Data initilizer for ESRemoteThreadCreateEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let threadEvent: RemoteThreadCreateEvent = message.event.remote_thread_create!
        let description = NSEntityDescription.entity(forEntityName: "ESRemoteThreadCreateEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = threadEvent.id
        self.thread_state = threadEvent.thread_state
        self.target = ESProcess(from: threadEvent.target, version: message.version, insertIntoManagedObjectContext: context)
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try thread_state = container.decode(String.self, forKey: .thread_state)
        try target = container.decode(ESProcess.self, forKey: .target)
    }
}

// MARK: - Encodable conformance
extension ESRemoteThreadCreateEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(thread_state, forKey: .thread_state)
        try container.encode(target, forKey: .target)
    }
}
