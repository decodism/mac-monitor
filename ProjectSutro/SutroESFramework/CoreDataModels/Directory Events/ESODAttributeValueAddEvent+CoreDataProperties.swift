//
//  ESODAttributeValueAddEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 6/28/23.
//
//

import Foundation
import CoreData


extension ESODAttributeValueAddEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESODAttributeValueAddEvent> {
        return NSFetchRequest<ESODAttributeValueAddEvent>(entityName: "ESODAttributeValueAddEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var instigator_process_name: String?
    @NSManaged public var instigator_process_path: String?
    @NSManaged public var instigator_process_audit_token: String?
    @NSManaged public var instigator_process_signing_id: String?
    @NSManaged public var error_code: Int32
    @NSManaged public var record_type: String?
    @NSManaged public var record_name: String?
    @NSManaged public var attribute_name: String?
    @NSManaged public var attribute_value: String?
    @NSManaged public var node_name: String?
    @NSManaged public var db_path: String?
    @NSManaged public var error_code_human: String?
}

extension ESODAttributeValueAddEvent : Identifiable {

}
