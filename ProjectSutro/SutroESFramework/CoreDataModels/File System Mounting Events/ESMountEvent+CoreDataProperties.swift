//
//  ESMountEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/17/23.
//
//

import Foundation
import CoreData


extension ESMountEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESMountEvent> {
        return NSFetchRequest<ESMountEvent>(entityName: "ESMountEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var total_files: Int64
    @NSManaged public var mount_flags: Int64
    @NSManaged public var type_name: String?
    @NSManaged public var source_name: String?
    @NSManaged public var mount_directory: String?
    @NSManaged public var owner_uid: Int64
    @NSManaged public var fs_id: String?
    @NSManaged public var owner_uid_human: String?

}

extension ESMountEvent : Identifiable {

}
