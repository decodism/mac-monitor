//
//  ESFileCloseEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/2/23.
//
//

import Foundation
import CoreData


extension ESFileCloseEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESFileCloseEvent> {
        return NSFetchRequest<ESFileCloseEvent>(entityName: "ESFileCloseEvent")
    }

    @NSManaged public var id: UUID
    @NSManaged public var target: ESFile
    @NSManaged public var modified: Bool
    
    // message >= 6
    @NSManaged public var was_mapped_writable: Bool

}

extension ESFileCloseEvent : Identifiable {

}
