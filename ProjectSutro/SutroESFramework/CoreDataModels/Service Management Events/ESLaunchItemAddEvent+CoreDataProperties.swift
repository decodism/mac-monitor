//
//  ESLaunchItemAddEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 11/15/22.
//
//

import Foundation
import CoreData


extension ESLaunchItemAddEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESLaunchItemAddEvent> {
        return NSFetchRequest<ESLaunchItemAddEvent>(entityName: "ESLaunchItemAddEvent")
    }

    @NSManaged public var file_name: String?
    @NSManaged public var file_path: String?
    @NSManaged public var id: UUID?
    @NSManaged public var uid: Int64
    @NSManaged public var uid_human: String?
    @NSManaged public var is_legacy: Bool
    @NSManaged public var is_managed: Bool
    @NSManaged public var type: String?
    @NSManaged public var plist_contents: String?
    @NSManaged public var app_process_path: String?
    @NSManaged public var app_process_signing_id: String?
    @NSManaged public var app_process_team_id: String?
    @NSManaged public var instigating_process_path: String?
    @NSManaged public var instigating_process_signing_id: String?
    @NSManaged public var instigating_process_team_id: String?

}

extension ESLaunchItemAddEvent : Identifiable {

}
