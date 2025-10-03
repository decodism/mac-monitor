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
public class ESOpenSSHLogoutEvent: NSManagedObject {
    enum CodingKeys: CodingKey {
        case id, result_type, source_address, source_address_type, success, username
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
