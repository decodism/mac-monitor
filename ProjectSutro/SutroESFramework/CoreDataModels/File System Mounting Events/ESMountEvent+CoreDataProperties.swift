//
//  ESMountEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/17/23.
//
//

import Foundation
import CoreData


extension ESMountEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESMountEvent> {
        return NSFetchRequest<ESMountEvent>(entityName: "ESMountEvent")
    }

    @NSManaged public var id: UUID
    
    @NSManaged public var statfsData: Data
    @NSManaged public var disposition: Int16
    @NSManaged public var disposition_string: String

}

extension ESMountEvent : Identifiable {

}
