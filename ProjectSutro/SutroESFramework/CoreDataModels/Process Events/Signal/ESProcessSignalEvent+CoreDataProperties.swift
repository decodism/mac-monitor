//
//  ESProcessSignalEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/2/23.
//
//

import Foundation
import CoreData


extension ESProcessSignalEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESProcessSignalEvent> {
        return NSFetchRequest<ESProcessSignalEvent>(entityName: "ESProcessSignalEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var sig: Int32
    @NSManaged public var signal_name: String
    @NSManaged public var target: ESProcess
    @NSManaged public var instigator: ESProcess?

}

extension ESProcessSignalEvent : Identifiable {

}
