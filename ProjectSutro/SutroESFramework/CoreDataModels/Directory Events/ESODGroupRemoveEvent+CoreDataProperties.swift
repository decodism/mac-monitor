//
//  ESODGroupRemoveEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 6/13/23.
//
//

import Foundation
import CoreData


extension ESODGroupRemoveEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESODGroupRemoveEvent> {
        return NSFetchRequest<ESODGroupRemoveEvent>(entityName: "ESODGroupRemoveEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var instigator_process_name: String?
    @NSManaged public var instigator_process_path: String?
    @NSManaged public var instigator_process_audit_token: String?
    @NSManaged public var instigator_process_signing_id: String?
    @NSManaged public var group_name: String?
    @NSManaged public var member: String?
    @NSManaged public var node_name: String?
    @NSManaged public var db_path: String?
    @NSManaged public var error_code: Int32
    @NSManaged public var error_code_human: String?
}

extension ESODGroupRemoveEvent : Identifiable {

}
