//
//  ESXattrSetEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/3/23.
//
//

import Foundation
import CoreData

@objc(ESXattrSetEvent)
public class ESXattrSetEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, file_name, file_path, xattr
    }
    
    // MARK: - Custom initilizer for ESXattrSetEvent during heavy flows
    convenience init(from message: Message) {
        let xattrEvent: XattrSetEvent = message.event.setextattr!
        self.init()
        self.id = xattrEvent.id
        self.xattr = xattrEvent.xattr!
        self.file_name = xattrEvent.file_name!
        self.file_path = xattrEvent.file_path!
    }
    
    // MARK: - Custom Core Data initilizer for ESXattrSetEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let xattrEvent: XattrSetEvent = message.event.setextattr!
        let description = NSEntityDescription.entity(forEntityName: "ESXattrSetEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = xattrEvent.id
        self.xattr = xattrEvent.xattr!
        self.file_name = xattrEvent.file_name!
        self.file_path = xattrEvent.file_path!
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try file_name = container.decode(String.self, forKey: .file_name)
        try file_path = container.decode(String.self, forKey: .file_path)
        try xattr = container.decode(String.self, forKey: .xattr)
    }
}

// MARK: - Encodable conformance
extension ESXattrSetEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(file_name, forKey: .file_name)
        try container.encode(file_path, forKey: .file_path)
        try container.encode(xattr, forKey: .xattr)
    }
}
