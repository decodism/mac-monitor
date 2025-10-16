//
//  ESProfileAddEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 6/5/23.
//
//

import Foundation
import CoreData


extension ESProfileAddEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESProfileAddEvent> {
        return NSFetchRequest<ESProfileAddEvent>(entityName: "ESProfileAddEvent")
    }

    @NSManaged public var id: UUID
    @NSManaged public var instigator: ESProcess?
    @NSManaged public var is_update: Bool
    @NSManaged public var profileData: Data?
    @NSManaged public var instigator_token: ESAuditToken?

}

extension ESProfileAddEvent : Identifiable {

}
