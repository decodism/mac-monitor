//
//  ESPTYGrantEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 9/29/25.
//
//

import Foundation
import CoreData


extension ESPTYGrantEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESPTYGrantEvent> {
        return NSFetchRequest<ESPTYGrantEvent>(entityName: "ESPTYGrantEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var dev: Int64

}

extension ESPTYGrantEvent : Identifiable {

}
