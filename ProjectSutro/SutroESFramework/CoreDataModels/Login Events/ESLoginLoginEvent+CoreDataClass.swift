//
//  ESLoginLoginEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/17/23.
//
//

import Foundation
import CoreData

@objc(ESLoginLoginEvent)
public class ESLoginLoginEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, success, failure_message, username, uid, uid_human
    }
    
    // MARK: - Custom initilizer for ESLoginLoginEvent during heavy flows
    convenience init(from message: Message) {
        let loginLoginEvent: LoginLoginEvent = message.event.login_login!
        self.init()
        
        self.id = loginLoginEvent.id
        self.success = loginLoginEvent.succcess
        self.failure_message = loginLoginEvent.failure_message
        self.username = loginLoginEvent.username
        self.uid = loginLoginEvent.uid
        self.uid_human = loginLoginEvent.uid_human
    }
    
    // MARK: - Custom Core Data initilizer for ESLoginLoginEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let loginLoginEvent: LoginLoginEvent = message.event.login_login!
        let description = NSEntityDescription.entity(forEntityName: "ESLoginLoginEvent", in: context)!
        self.init(entity: description, insertInto: context)
        
        self.id = loginLoginEvent.id
        self.success = loginLoginEvent.succcess
        self.failure_message = loginLoginEvent.failure_message
        self.username = loginLoginEvent.username
        self.uid = loginLoginEvent.uid
        self.uid_human = loginLoginEvent.uid_human
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try success = container.decode(Bool.self, forKey: .success)
        try failure_message = container.decode(String.self, forKey: .failure_message)
        try username = container.decode(String.self, forKey: .username)
        try uid = container.decode(Int64.self, forKey: .uid)
        try uid_human = container.decode(String.self, forKey: .uid_human)
    }
}

// MARK: - Encodable conformance
extension ESLoginLoginEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
//        try container.encode(id, forKey: .id)
        try container.encode(success, forKey: .success)
        try container.encode(failure_message, forKey: .failure_message)
        try container.encode(username, forKey: .username)
        try container.encode(uid, forKey: .uid)
        try container.encode(uid_human, forKey: .uid_human)
    }
}
