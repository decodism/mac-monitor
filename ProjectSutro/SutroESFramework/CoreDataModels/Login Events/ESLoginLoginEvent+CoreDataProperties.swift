//
//  ESLoginLoginEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/17/23.
//
//

import Foundation
import CoreData


extension ESLoginLoginEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESLoginLoginEvent> {
        return NSFetchRequest<ESLoginLoginEvent>(entityName: "ESLoginLoginEvent")
    }

    @NSManaged public var id: UUID
    @NSManaged public var success: Bool
    @NSManaged public var failure_message: String?
    @NSManaged public var username: String?
    @NSManaged public var uid: NSNumber?
    @NSManaged public var uid_human: String?
    @NSManaged public var has_uid: Bool

}

extension ESLoginLoginEvent : Identifiable {

}
