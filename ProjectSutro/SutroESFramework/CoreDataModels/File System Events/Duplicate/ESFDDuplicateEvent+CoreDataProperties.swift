//
//  ESFDDuplicateEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 2/16/23.
//
//

import Foundation
import CoreData


extension ESFDDuplicateEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESFDDuplicateEvent> {
        return NSFetchRequest<ESFDDuplicateEvent>(entityName: "ESFDDuplicateEvent")
    }

    @NSManaged public var id: UUID
    @NSManaged public var target: ESFile

}

extension ESFDDuplicateEvent : Identifiable {

}
