//
//  ESUIPCBindEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 10/1/25.
//
//

import Foundation
import CoreData


@objc(ESUIPCBindEvent)
public class ESUIPCBindEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case dir
        case filename
        case mode
    }
    
    convenience init(from message: Message) {
        let event: UIPCBindEvent = message.event.uipc_bind!
        self.init()
        self.id = event.id
        
        self.dir = ESFile(from: event.dir)
        self.filename = event.filename
        self.mode = event.mode
    }
    
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let event: UIPCBindEvent = message.event.uipc_bind!
        let description = NSEntityDescription.entity(forEntityName: "ESUIPCBindEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = event.id
        
        self.dir = ESFile(from: event.dir, insertIntoManagedObjectContext: context)
        self.filename = event.filename
        self.mode = event.mode
    }
    
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try dir = container.decode(ESFile.self, forKey: .dir)
        try filename = container.decode(String.self, forKey: .filename)
        try mode = container.decode(Int32.self, forKey: .mode)
    }
}

extension ESUIPCBindEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(dir, forKey: .dir)
        try container.encode(filename, forKey: .filename)
        try container.encode(mode, forKey: .mode)
    }
}

