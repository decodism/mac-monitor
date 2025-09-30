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

    @NSManaged public var id: UUID?
    @NSManaged public var instigator_process_name: String?
    @NSManaged public var instigator_process_path: String?
    @NSManaged public var instigator_process_audit_token: String?
    @NSManaged public var instigator_process_signing_id: String?
    @NSManaged public var is_update: Bool
    @NSManaged public var profile_identifier: String?
    @NSManaged public var profile_uuid: String?
    @NSManaged public var profile_organization: String?
    @NSManaged public var profile_display_name: String?
    @NSManaged public var profile_scope: String?
    @NSManaged public var profile_source_type: String?

}

extension ESProfileAddEvent : Identifiable {

}
