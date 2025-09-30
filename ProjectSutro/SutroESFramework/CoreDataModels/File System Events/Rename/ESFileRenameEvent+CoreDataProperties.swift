//
//  ESFileRenameEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 2/17/23.
//
//

import Foundation
import CoreData


extension ESFileRenameEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESFileRenameEvent> {
        return NSFetchRequest<ESFileRenameEvent>(entityName: "ESFileRenameEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var file_name: String?
    @NSManaged public var destination_path: String?
    @NSManaged public var source_path: String?
    @NSManaged public var archive_files_not_quarantined: String?
    @NSManaged public var type: String?
    @NSManaged public var is_quarantined: Int16

}

extension ESFileRenameEvent : Identifiable {

}
