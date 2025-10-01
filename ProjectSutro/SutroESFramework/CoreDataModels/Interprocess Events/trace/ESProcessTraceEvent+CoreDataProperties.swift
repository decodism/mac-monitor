//
//  ESProcessTraceEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/3/23.
//
//

import Foundation
import CoreData


extension ESProcessTraceEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESProcessTraceEvent> {
        return NSFetchRequest<ESProcessTraceEvent>(entityName: "ESProcessTraceEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var target: ESProcess

}

extension ESProcessTraceEvent : Identifiable {

}
