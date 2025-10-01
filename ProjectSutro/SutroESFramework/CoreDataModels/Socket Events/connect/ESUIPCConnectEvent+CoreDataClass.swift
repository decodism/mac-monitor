//
//  ESUIPCConnectEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 10/1/25.
//
//

import Foundation
import CoreData


@objc(ESUIPCConnectEvent)
public class ESUIPCConnectEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case file
        case domain
        case type
        case `protocol`
        case type_string
        case domain_string
        case protocol_string
    }
    
    convenience init(from message: Message) {
        let event: UIPCConnectEvent = message.event.uipc_connect!
        self.init()
        self.id = event.id
        
        self.file = ESFile(from: event.file)
        self.domain = event.domain
        self.type = event.type
        self.protocol = event.protocol
        self.type_string = event.type_string
        self.domain_string = event.domain_string
        self.protocol_string = event.protocol_string
    }
    
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let event: UIPCConnectEvent = message.event.uipc_connect!
        let description = NSEntityDescription.entity(forEntityName: "ESUIPCConnectEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = event.id
        
        self.file = ESFile(from: event.file, insertIntoManagedObjectContext: context)
        self.domain = event.domain
        self.type = event.type
        self.protocol = event.protocol
        self.type_string = event.type_string
        self.domain_string = event.domain_string
        self.protocol_string = event.protocol_string
    }
    
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try file = container.decode(ESFile.self, forKey: .file)
        try domain = container.decode(Int32.self, forKey: .domain)
        try type = container.decode(Int32.self, forKey: .type)
        try `protocol` = container.decode(Int32.self, forKey: .protocol)
        
        try type_string = container.decode(String.self, forKey: .type_string)
        try domain_string = container.decode(String.self, forKey: .domain_string)
        try protocol_string = container.decode(String.self, forKey: .protocol_string)
    }
}

extension ESUIPCConnectEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(file, forKey: .file)
        try container.encode(domain, forKey: .domain)
        try container.encode(type, forKey: .type)
        try container.encode(`protocol`, forKey: .protocol)
        
        try container.encode(type_string, forKey: .type_string)
        try container.encode(domain_string, forKey: .domain_string)
        try container.encode(protocol_string, forKey: .protocol_string)
    }
}

