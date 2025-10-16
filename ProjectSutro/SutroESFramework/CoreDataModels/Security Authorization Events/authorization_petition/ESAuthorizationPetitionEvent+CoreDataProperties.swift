//
//  ESAuthorizationPetitionEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 6/27/23.
//
//

import Foundation
import CoreData


extension ESAuthorizationPetitionEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESAuthorizationPetitionEvent> {
        return NSFetchRequest<ESAuthorizationPetitionEvent>(entityName: "ESAuthorizationPetitionEvent")
    }

    @NSManaged public var id: UUID
    @NSManaged public var instigator: ESProcess?
    @NSManaged public var petitioner: ESProcess?
    @NSManaged public var flags: Int64
    @NSManaged public var flagsData: Data?
    @NSManaged public var right_count: Int32
    @NSManaged public var rightsData: Data?
    @NSManaged public var instigator_token: ESAuditToken?
    @NSManaged public var petitioner_token: ESAuditToken?

}

extension ESAuthorizationPetitionEvent : Identifiable {

}
