//
//  ESODCreateUserEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 6/7/23.
//
//

import Foundation
import CoreData


extension ESODCreateUserEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESODCreateUserEvent> {
        return NSFetchRequest<ESODCreateUserEvent>(entityName: "ESODCreateUserEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var instigator_process_name: String?
    @NSManaged public var instigator_process_path: String?
    @NSManaged public var instigator_process_audit_token: String?
    @NSManaged public var instigator_process_signing_id: String?
    @NSManaged public var user_name: String?
    @NSManaged public var node_name: String?
    @NSManaged public var db_path: String?
    @NSManaged public var error_code: Int32
    @NSManaged public var error_code_human: String?
}

extension ESODCreateUserEvent : Identifiable {

}
