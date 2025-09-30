//
//  ESOpenSSHLogoutEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/13/23.
//
//

import Foundation
import CoreData

@objc(ESOpenSSHLogoutEvent)
public class ESOpenSSHLogoutEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, result_type, source_address, source_address_type, success, username
    }
    
    // MARK: - Custom initilizer for ESOpenSSHLogoutEvent during heavy flows
    convenience init(from message: Message) {
        let sshLogoutEvent: SSHLogoutEvent = message.event.openssh_logout!
        self.init()
        self.id = sshLogoutEvent.id
        self.source_address = sshLogoutEvent.source_address
        self.source_address_type = sshLogoutEvent.source_address_type
        self.username = sshLogoutEvent.username
    }
    
    // MARK: - Custom Core Data initilizer for ESOpenSSHLogoutEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let sshLogoutEvent: SSHLogoutEvent = message.event.openssh_logout!
        let description = NSEntityDescription.entity(forEntityName: "ESOpenSSHLogoutEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = sshLogoutEvent.id
        self.source_address = sshLogoutEvent.source_address
        self.source_address_type = sshLogoutEvent.source_address_type
        self.username = sshLogoutEvent.username
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try source_address = container.decode(String.self, forKey: .source_address)
        try source_address_type = container.decode(String.self, forKey: .source_address_type)
        try username = container.decode(String.self, forKey: .username)
    }
}

// MARK: - Encodable conformance
extension ESOpenSSHLogoutEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
        try container.encode(source_address, forKey: .source_address)
        try container.encode(source_address_type, forKey: .source_address_type)
        try container.encode(username, forKey: .username)
    }
}
