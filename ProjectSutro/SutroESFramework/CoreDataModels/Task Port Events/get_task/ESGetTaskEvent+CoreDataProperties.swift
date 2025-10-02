//
//  ESGetTaskEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/3/23.
//
//

import Foundation
import CoreData


extension ESGetTaskEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESGetTaskEvent> {
        return NSFetchRequest<ESGetTaskEvent>(entityName: "ESGetTaskEvent")
    }

    @NSManaged public var id: UUID
    @NSManaged public var target: ESProcess
    @NSManaged public var type: Int16
    @NSManaged public var type_string: String

}

extension ESGetTaskEvent : Identifiable {

}
