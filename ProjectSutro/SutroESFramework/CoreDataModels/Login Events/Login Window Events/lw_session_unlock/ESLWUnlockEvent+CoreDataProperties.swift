//
//  ESLWUnlockEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/18/23.
//
//

import Foundation
import CoreData


extension ESLWUnlockEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESLWUnlockEvent> {
        return NSFetchRequest<ESLWUnlockEvent>(entityName: "ESLWUnlockEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var username: String?
    @NSManaged public var graphical_session_id: Int32

}

extension ESLWUnlockEvent : Identifiable {

}
