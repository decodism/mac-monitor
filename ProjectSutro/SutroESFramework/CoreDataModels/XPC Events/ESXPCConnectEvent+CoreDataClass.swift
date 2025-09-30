//
//  ESXPCConnectEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 6/24/23.
//
//

import Foundation
import CoreData

@objc(ESXPCConnectEvent)
public class ESXPCConnectEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, service_name, service_domain_type, service_domain_type_string
    }
    
    convenience init(from message: Message) {
        let xpcConnectEvent: XPCConnectEvent = message.event.xpc_connect!
        self.init()
        
        self.id = xpcConnectEvent.id
        self.service_name = xpcConnectEvent.service_name
        self.service_domain_type = Int32(xpcConnectEvent.service_domain_type)
        self.service_domain_type_string = xpcConnectEvent.service_domain_type_string
    }
    
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let xpcConnectEvent: XPCConnectEvent = message.event.xpc_connect!
        let description = NSEntityDescription.entity(forEntityName: "ESXPCConnectEvent", in: context)!
        self.init(entity: description, insertInto: context)
        
        self.id = xpcConnectEvent.id
        self.service_name = xpcConnectEvent.service_name
        self.service_domain_type = Int32(xpcConnectEvent.service_domain_type)
        self.service_domain_type_string = xpcConnectEvent.service_domain_type_string
    }
    
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try service_name = container.decode(String.self, forKey: .service_name)
        try service_domain_type = container.decode(Int32.self, forKey: .service_domain_type)
        try service_domain_type_string = container.decode(String.self, forKey: .service_domain_type_string)
    }
}

extension ESXPCConnectEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(service_name, forKey: .service_name)
        try container.encode(service_domain_type_string, forKey: .service_domain_type_string)
        try container.encode(service_domain_type, forKey: .service_domain_type)
    }
}

