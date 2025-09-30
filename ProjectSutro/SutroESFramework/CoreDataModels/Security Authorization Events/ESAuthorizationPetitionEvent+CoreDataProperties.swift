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

    @NSManaged public var id: UUID?
    @NSManaged public var instigator_process_name: String?
    @NSManaged public var instigator_process_path: String?
    @NSManaged public var instigator_process_audit_token: String?
    @NSManaged public var instigator_process_signing_id: String?
    @NSManaged public var petitioner_process_name: String?
    @NSManaged public var petitioner_process_path: String?
    @NSManaged public var petitioner_process_audit_token: String?
    @NSManaged public var petitioner_process_signing_id: String?
    @NSManaged public var flags: String?
    @NSManaged public var right_count: Int32
    @NSManaged public var rights: String?

}

extension ESAuthorizationPetitionEvent : Identifiable {

}
