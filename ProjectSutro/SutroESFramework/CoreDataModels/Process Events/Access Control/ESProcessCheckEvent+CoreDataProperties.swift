//
//  ESProcessCheckEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/3/23.
//
//

import Foundation
import CoreData


extension ESProcessCheckEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESProcessCheckEvent> {
        return NSFetchRequest<ESProcessCheckEvent>(entityName: "ESProcessCheckEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var flavor: Int32
    @NSManaged public var type: Int32
    @NSManaged public var type_string: String
    @NSManaged public var target: ESProcess?

}

extension ESProcessCheckEvent : Identifiable {

}
