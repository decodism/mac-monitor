//
//  ESFileCreateEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 11/15/22.
//
//

import Foundation
import CoreData


extension ESFileCreateEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESFileCreateEvent> {
        return NSFetchRequest<ESFileCreateEvent>(entityName: "ESFileCreateEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var acl: String?
    @NSManaged public var is_quarantined: Int16
    @NSManaged public var destination_type: Int16
    @NSManaged public var destination_type_string: String
    @NSManaged public var destination: ESFileDestination

}

extension ESFileCreateEvent : Identifiable {

}
