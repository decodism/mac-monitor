//
//  ESLaunchItemRemoveEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 12/14/22.
//
//

import Foundation
import CoreData


extension ESLaunchItemRemoveEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESLaunchItemRemoveEvent> {
        return NSFetchRequest<ESLaunchItemRemoveEvent>(entityName: "ESLaunchItemRemoveEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var app_process_path: String?
    @NSManaged public var app_process_signing_id: String?
    @NSManaged public var app_process_team_id: String?
    @NSManaged public var instigating_process_path: String?
    @NSManaged public var instigating_process_signing_id: String?
    @NSManaged public var instigating_process_team_id: String?
    @NSManaged public var file_path: String?
    @NSManaged public var file_name: String?
    @NSManaged public var is_legacy: Bool
    @NSManaged public var type: String?
    @NSManaged public var uid: Int64
    @NSManaged public var uid_human: String?
    @NSManaged public var is_managed: Bool

}

extension ESLaunchItemRemoveEvent : Identifiable {

}
