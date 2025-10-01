//
//  ESXattrDeleteEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 11/15/22.
//
//

import Foundation
import CoreData


extension ESXattrDeleteEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESXattrDeleteEvent> {
        return NSFetchRequest<ESXattrDeleteEvent>(entityName: "ESXattrDeleteEvent")
    }

    @NSManaged public var id: UUID
    @NSManaged public var target: ESFile
    @NSManaged public var extattr: String

}

extension ESXattrDeleteEvent : Identifiable {

}
