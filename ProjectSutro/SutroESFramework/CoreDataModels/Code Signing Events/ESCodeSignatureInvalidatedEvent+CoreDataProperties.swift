//
//  ESCodeSignatureInvalidatedEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/3/23.
//
//

import Foundation
import CoreData


extension ESCodeSignatureInvalidatedEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESCodeSignatureInvalidatedEvent> {
        return NSFetchRequest<ESCodeSignatureInvalidatedEvent>(entityName: "ESCodeSignatureInvalidatedEvent")
    }

    @NSManaged public var id: UUID?

}

extension ESCodeSignatureInvalidatedEvent : Identifiable {

}
