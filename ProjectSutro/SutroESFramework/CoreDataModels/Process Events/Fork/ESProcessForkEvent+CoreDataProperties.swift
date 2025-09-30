//
//  ESProcessForkEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 11/15/22.
//
//

import Foundation
import CoreData


extension ESProcessForkEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESProcessForkEvent> {
        return NSFetchRequest<ESProcessForkEvent>(entityName: "ESProcessForkEvent")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var child: ESProcess

}

extension ESProcessForkEvent : Identifiable {

}
