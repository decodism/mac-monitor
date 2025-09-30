//
//  ESLWLoginEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/18/23.
//
//

import Foundation
import CoreData

@objc(ESLWLoginEvent)
public class ESLWLoginEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, username, graphical_session_id
    }
    
    // MARK: - Custom initilizer for ESLWLoginEvent during heavy flows
    convenience init(from message: Message) {
        let lwLoginEvent: LWLoginEvent = message.event.lw_session_login!
        self.init()
        
        self.id = lwLoginEvent.id
        self.username = lwLoginEvent.username
        self.graphical_session_id = lwLoginEvent.graphical_session_id
    }
    
    // MARK: - Custom Core Data initilizer for ESLWLoginEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let lwLoginEvent: LWLoginEvent = message.event.lw_session_login!
        let description = NSEntityDescription.entity(forEntityName: "ESLWLoginEvent", in: context)!
        self.init(entity: description, insertInto: context)
        
        self.id = lwLoginEvent.id
        self.username = lwLoginEvent.username
        self.graphical_session_id = lwLoginEvent.graphical_session_id
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try username = container.decode(String.self, forKey: .username)
        try graphical_session_id = container.decode(Int32.self, forKey: .graphical_session_id)
    }
}

// MARK: - Encodable conformance
extension ESLWLoginEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
//        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(graphical_session_id, forKey: .graphical_session_id)
    }
}
