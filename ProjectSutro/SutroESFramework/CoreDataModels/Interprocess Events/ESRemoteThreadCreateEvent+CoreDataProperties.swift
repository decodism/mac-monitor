//
//  ESRemoteThreadCreateEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/2/23.
//
//

import Foundation
import CoreData


extension ESRemoteThreadCreateEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESRemoteThreadCreateEvent> {
        return NSFetchRequest<ESRemoteThreadCreateEvent>(entityName: "ESRemoteThreadCreateEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var target: ESProcess
    @NSManaged public var thread_state: String

}

extension ESRemoteThreadCreateEvent : Identifiable {

}
