//
//  ESProcessSocketEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/3/23.
//
//

import Foundation
import CoreData


extension ESProcessSocketEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESProcessSocketEvent> {
        return NSFetchRequest<ESProcessSocketEvent>(entityName: "ESProcessSocketEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var type: Int32
    @NSManaged public var type_string: String
    @NSManaged public var target: ESProcess?

}

extension ESProcessSocketEvent : Identifiable {

}
