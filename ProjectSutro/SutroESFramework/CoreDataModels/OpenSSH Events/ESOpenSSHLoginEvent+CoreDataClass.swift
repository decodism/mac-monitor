//
//  ESOpenSSHLoginEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 12/14/22.
//
//

import Foundation
import CoreData

@objc(ESOpenSSHLoginEvent)
public class ESOpenSSHLoginEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, result_type, source_address, source_address_type, success, user_name
    }
    
    // MARK: - Custom initilizer for ESOpenSSHLoginEvent during heavy flows
    convenience init(from message: Message) {
        let sshLoginEvent: SSHLoginEvent = message.event.openssh_login!
        self.init()
        self.id = sshLoginEvent.id
        self.result_type = sshLoginEvent.result_type
        self.source_address = sshLoginEvent.source_address
        self.source_address_type = sshLoginEvent.source_address_type
        self.success = sshLoginEvent.success
        self.user_name = sshLoginEvent.user_name
    }
    
    // MARK: - Custom Core Data initilizer for ESOpenSSHLoginEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let sshLoginEvent: SSHLoginEvent = message.event.openssh_login!
        let description = NSEntityDescription.entity(forEntityName: "ESOpenSSHLoginEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = sshLoginEvent.id
        self.result_type = sshLoginEvent.result_type
        self.source_address = sshLoginEvent.source_address
        self.source_address_type = sshLoginEvent.source_address_type
        self.success = sshLoginEvent.success
        self.user_name = sshLoginEvent.user_name
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try result_type = container.decode(String.self, forKey: .result_type)
        try source_address = container.decode(String.self, forKey: .source_address)
        try source_address_type = container.decode(String.self, forKey: .source_address_type)
        try success = container.decode(Bool.self, forKey: .success)
        try user_name = container.decode(String.self, forKey: .user_name)
    }
}

// MARK: - Encodable conformance
extension ESOpenSSHLoginEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
        try container.encode(result_type, forKey: .result_type)
        try container.encode(source_address, forKey: .source_address)
        try container.encode(source_address_type, forKey: .source_address_type)
        try container.encode(success, forKey: .success)
        try container.encode(user_name, forKey: .user_name)
    }
}
