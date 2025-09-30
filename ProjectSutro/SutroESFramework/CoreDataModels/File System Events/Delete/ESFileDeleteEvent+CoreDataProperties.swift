//
//  ESFileDeleteEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/1/23.
//
//

import Foundation
import CoreData


extension ESFileDeleteEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESFileDeleteEvent> {
        return NSFetchRequest<ESFileDeleteEvent>(entityName: "ESFileDeleteEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var file_path: String?
    @NSManaged public var file_name: String?
    @NSManaged public var parent_directory: String?

}

extension ESFileDeleteEvent : Identifiable {

}
