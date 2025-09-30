//
//  ESSetModeEvent+CoreDataProperties.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 9/29/25.
//
//

import Foundation
import CoreData



extension ESSetModeEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESSetModeEvent> {
        return NSFetchRequest<ESSetModeEvent>(entityName: "ESSetModeEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var mode: Int32
    @NSManaged public var target: ESFile

}

extension ESSetModeEvent : Identifiable {

}
