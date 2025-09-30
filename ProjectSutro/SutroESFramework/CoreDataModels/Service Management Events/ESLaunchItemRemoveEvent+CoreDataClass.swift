//
//  ESLaunchItemRemoveEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 12/14/22.
//
// References:
// - Codable conformance to NSManagedObject: https://gist.github.com/Akhu/5ea1ecbd652fb269f7c4e7db27bc79cc
//

import Foundation
import CoreData

@objc(ESLaunchItemRemoveEvent)
public class ESLaunchItemRemoveEvent: NSManagedObject, Decodable  {
    enum CodingKeys: CodingKey {
        case id, app_process_path, app_process_signing_id, app_process_team_id, instigating_process_path, instigating_process_signing_id, instigating_process_team_id, file_path, file_name, legacy, type, uid, uid_human, is_managed
    }
    
    // MARK: - Custom initilizer for ESLaunchItemRemoveEvent during heavy flows
    convenience init(from message: Message) {
        let launchItemRemoveEvent: LaunchItemRemoveEvent = message.event.btm_launch_item_remove!
        self.init()
        
        self.id = launchItemRemoveEvent.id
        self.app_process_path = launchItemRemoveEvent.app_process_path
        self.app_process_team_id = launchItemRemoveEvent.app_process_team_id
        self.app_process_signing_id = launchItemRemoveEvent.app_process_signing_id
        self.instigating_process_path = launchItemRemoveEvent.instigating_process_path
        self.instigating_process_signing_id = launchItemRemoveEvent.instigating_process_signing_id
        self.instigating_process_team_id = launchItemRemoveEvent.instigating_process_team_id
        self.file_path = launchItemRemoveEvent.file_path
        self.file_name = launchItemRemoveEvent.file_name
        self.type = launchItemRemoveEvent.type
        
//        self.uid = launchItemRemoveEvent.uid
//        self.uid_human = launchItemRemoveEvent.uid_human
    }
    
    // MARK: - Custom Core Data initilizer for ESLaunchItemRemoveEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let launchItemRemoveEvent: LaunchItemRemoveEvent = message.event.btm_launch_item_remove!
        let description = NSEntityDescription.entity(forEntityName: "ESLaunchItemRemoveEvent", in: context)!
        self.init(entity: description, insertInto: context)
        
        self.id = launchItemRemoveEvent.id
        self.app_process_path = launchItemRemoveEvent.app_process_path
        self.app_process_team_id = launchItemRemoveEvent.app_process_team_id
        self.app_process_signing_id = launchItemRemoveEvent.app_process_signing_id
        self.instigating_process_path = launchItemRemoveEvent.instigating_process_path
        self.instigating_process_signing_id = launchItemRemoveEvent.instigating_process_signing_id
        self.instigating_process_team_id = launchItemRemoveEvent.instigating_process_team_id
        self.file_path = launchItemRemoveEvent.file_path
        self.file_name = launchItemRemoveEvent.file_name
        self.type = launchItemRemoveEvent.type
        
//        self.uid = launchItemRemoveEvent.uid
//        self.uid_human = launchItemRemoveEvent.uid_human
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try app_process_path = container.decode(String.self, forKey: .app_process_path)
        try app_process_team_id = container.decode(String.self, forKey: .app_process_team_id)
        try app_process_signing_id = container.decode(String.self, forKey: .app_process_signing_id)
        try instigating_process_path = container.decode(String.self, forKey: .instigating_process_path)
        try instigating_process_signing_id = container.decode(String.self, forKey: .instigating_process_signing_id)
        try instigating_process_team_id = container.decode(String.self, forKey: .instigating_process_team_id)
        try file_path = container.decode(String.self, forKey: .file_path)
        try file_name = container.decode(String.self, forKey: .file_name)
        try type = container.decode(String.self, forKey: .type)
//        try uid = container.decode(Int64.self, forKey: .uid)
//        try uid_human = container.decode(String.self, forKey: .uid_human)
    }

}

// MARK: - Encodable conformance
extension ESLaunchItemRemoveEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
        try container.encode(app_process_path, forKey: .app_process_path)
        try container.encode(app_process_team_id, forKey: .app_process_team_id)
        try container.encode(app_process_signing_id, forKey: .app_process_signing_id)
        try container.encode(instigating_process_path, forKey: .instigating_process_path)
        try container.encode(instigating_process_signing_id, forKey: .instigating_process_signing_id)
        try container.encode(instigating_process_team_id, forKey: .instigating_process_team_id)
        try container.encode(file_path, forKey: .file_path)
        try container.encode(file_name, forKey: .file_name)
        try container.encode(type, forKey: .type)
        
//        try container.encode(uid, forKey: .uid)
//        try container.encode(uid_human, forKey: .uid_human)
    }
}
