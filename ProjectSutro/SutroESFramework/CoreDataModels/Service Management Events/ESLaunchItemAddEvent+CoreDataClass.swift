//
//  ESLaunchItemAddEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 11/15/22.
//
//

import Foundation
import CoreData

@objc(ESLaunchItemAddEvent)
public class ESLaunchItemAddEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, file_name, file_path, is_legacy, is_managed, type, plist_contents, app_process_path, app_process_signing_id, app_process_team_id, instigating_process_path, instigating_process_signing_id, instigating_process_team_id, uid, uid_human
    }
    
    // MARK: - Custom initilizer for ESLaunchItemAddEvent during heavy flows
    convenience init(from message: Message) {
        let launchItem: LaunchItemAddEvent = message.event.btm_launch_item_add!
        self.init()
        self.id = launchItem.id
        
        self.app_process_path = launchItem.app_process_path
        self.app_process_team_id = launchItem.app_process_team_id
        self.app_process_signing_id = launchItem.app_process_signing_id
        self.instigating_process_path = launchItem.instigating_process_path
        self.instigating_process_signing_id = launchItem.instigating_process_signing_id
        self.instigating_process_team_id = launchItem.instigating_process_team_id
        self.file_name = launchItem.file_name
        self.file_path = launchItem.file_path
        self.is_legacy = launchItem.is_legacy
        self.type = launchItem.type
        self.plist_contents = launchItem.plist_contents
//        self.uid = launchItem.uid
//        self.uid_human = launchItem.uid_human
        self.is_managed = launchItem.is_managed
    }
    
    // MARK: - Custom Core Data initilizer for ESLaunchItemAddEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let launchItem: LaunchItemAddEvent = message.event.btm_launch_item_add!
        let description = NSEntityDescription.entity(forEntityName: "ESLaunchItemAddEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = launchItem.id
        
        self.file_name = launchItem.file_name
        self.file_path = launchItem.file_path
        self.is_legacy = launchItem.is_legacy
        self.type = launchItem.type
        self.plist_contents = launchItem.plist_contents
        self.app_process_path = launchItem.app_process_path
        self.app_process_team_id = launchItem.app_process_team_id
        self.app_process_signing_id = launchItem.app_process_signing_id
        self.instigating_process_path = launchItem.instigating_process_path
        self.instigating_process_signing_id = launchItem.instigating_process_signing_id
        self.instigating_process_team_id = launchItem.instigating_process_team_id
//        self.uid = launchItem.uid
//        self.uid_human = launchItem.uid_human
        self.is_managed = launchItem.is_managed
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try file_name = container.decode(String.self, forKey: .file_name)
        try file_path = container.decode(String.self, forKey: .file_path)
        try is_legacy = container.decode(Bool.self, forKey: .is_legacy)
        try is_managed = container.decode(Bool.self, forKey: .is_managed)
        try type = container.decode(String.self, forKey: .type)
        try plist_contents = container.decode(String.self, forKey: .plist_contents)
        
        try app_process_path = container.decode(String.self, forKey: .app_process_path)
        try app_process_team_id = container.decode(String.self, forKey: .app_process_team_id)
        try app_process_signing_id = container.decode(String.self, forKey: .app_process_signing_id)
        try instigating_process_path = container.decode(String.self, forKey: .instigating_process_path)
        try instigating_process_signing_id = container.decode(String.self, forKey: .instigating_process_signing_id)
        try instigating_process_team_id = container.decode(String.self, forKey: .instigating_process_team_id)
        
//        try uid = container.decode(Int64.self, forKey: .uid)
//        try uid_human = container.decode(String.self, forKey: .uid_human)
    }
}

// MARK: - Encodable conformance
extension ESLaunchItemAddEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
        try container.encode(file_name, forKey: .file_name)
        try container.encode(file_path, forKey: .file_path)
        try container.encode(is_legacy, forKey: .is_legacy)
        try container.encode(type, forKey: .type)
        try container.encode(plist_contents, forKey: .plist_contents)
        try container.encode(is_managed, forKey: .is_managed)
        
        try container.encode(app_process_path, forKey: .app_process_path)
        try container.encode(app_process_team_id, forKey: .app_process_team_id)
        try container.encode(app_process_signing_id, forKey: .app_process_signing_id)
        try container.encode(instigating_process_path, forKey: .instigating_process_path)
        try container.encode(instigating_process_signing_id, forKey: .instigating_process_signing_id)
        try container.encode(instigating_process_team_id, forKey: .instigating_process_team_id)
        
//        try container.encode(uid, forKey: .uid)
//        try container.encode(uid_human, forKey: .uid_human)
    }
}
