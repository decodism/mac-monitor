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

    @NSManaged public var id: UUID
    @NSManaged public var target: ESFile
    @NSManaged public var parent_dir: ESFile

}

extension ESFileDeleteEvent : Identifiable {

}
