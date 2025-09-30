//
//  ESMountEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/17/23.
//
//

import Foundation
import CoreData

@objc(ESMountEvent)
public class ESMountEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, type_name, source_name, mount_directory, fs_id, total_files, owner_uid, mount_flags, owner_uid_human
    }
    
    // MARK: - Custom initilizer for ESMountEvent during heavy flows
    convenience init(from message: Message) {
        let mountEvent: MountEvent = message.event.mount!
        self.init()
        self.id = mountEvent.id
        self.type_name = mountEvent.type_name
        self.source_name = mountEvent.source_name
        self.mount_directory = mountEvent.mount_directory
        self.fs_id = mountEvent.fs_id
        self.total_files = mountEvent.total_files
        self.owner_uid = mountEvent.owner_uid
        self.mount_flags = mountEvent.mount_flags
        self.owner_uid_human = mountEvent.owner_uid_human
    }
    
    // MARK: - Custom Core Data initilizer for ESMountEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let mountEvent: MountEvent = message.event.mount!
        let description = NSEntityDescription.entity(forEntityName: "ESMountEvent", in: context)!
        self.init(entity: description, insertInto: context)
        
        self.id = mountEvent.id
        self.type_name = mountEvent.type_name
        self.type_name = mountEvent.type_name
        self.source_name = mountEvent.source_name
        self.mount_directory = mountEvent.mount_directory
        self.fs_id = mountEvent.fs_id
        self.total_files = mountEvent.total_files
        self.owner_uid = mountEvent.owner_uid
        self.mount_flags = mountEvent.mount_flags
        self.owner_uid_human = mountEvent.owner_uid_human
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try type_name = container.decode(String.self, forKey: .type_name)
        try source_name = container.decode(String.self, forKey: .source_name)
        try mount_directory = container.decode(String.self, forKey: .mount_directory)
        try fs_id = container.decode(String.self, forKey: .fs_id)
        try total_files = container.decode(Int64.self, forKey: .total_files)
        try owner_uid = container.decode(Int64.self, forKey: .owner_uid)
        try mount_flags = container.decode(Int64.self, forKey: .mount_flags)
        try owner_uid_human = container.decode(String.self, forKey: .owner_uid_human)
    }
}

// MARK: - Encodable conformance
extension ESMountEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
//        try container.encode(id, forKey: .id)
        try container.encode(type_name, forKey: .type_name)
        try container.encode(source_name, forKey: .source_name)
        try container.encode(mount_directory, forKey: .mount_directory)
        try container.encode(fs_id, forKey: .fs_id)
        try container.encode(total_files, forKey: .total_files)
        try container.encode(owner_uid, forKey: .owner_uid)
        try container.encode(mount_flags, forKey: .mount_flags)
        try container.encode(owner_uid_human, forKey: .owner_uid_human)
    }
}
