//
//  EmittedEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 2/8/23.
//
//

import Foundation
import CoreData


extension EmittedEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmittedEvent> {
        return NSFetchRequest<EmittedEvent>(entityName: "EmittedEvent")
    }
    
    @NSManaged public var timestamp: Int64
    @NSManaged public var event_json: String?
    
}

extension EmittedEvent : Identifiable {

}
