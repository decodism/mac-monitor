//
//  ESXattrSetEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/3/23.
//
//

import Foundation
import CoreData


extension ESXattrSetEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESXattrSetEvent> {
        return NSFetchRequest<ESXattrSetEvent>(entityName: "ESXattrSetEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var file_name: String?
    @NSManaged public var file_path: String?
    @NSManaged public var xattr: String?

}

extension ESXattrSetEvent : Identifiable {

}
