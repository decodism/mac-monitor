//
//  ESLWLoginEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/18/23.
//
//

import Foundation
import CoreData


extension ESLWLoginEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESLWLoginEvent> {
        return NSFetchRequest<ESLWLoginEvent>(entityName: "ESLWLoginEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var username: String?
    @NSManaged public var graphical_session_id: Int32

}

extension ESLWLoginEvent : Identifiable {

}
