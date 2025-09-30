//
//  ESODModifyPasswordEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 6/7/23.
//
//

import Foundation
import CoreData


extension ESODModifyPasswordEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESODModifyPasswordEvent> {
        return NSFetchRequest<ESODModifyPasswordEvent>(entityName: "ESODModifyPasswordEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var instigator_process_name: String?
    @NSManaged public var instigator_process_path: String?
    @NSManaged public var instigator_process_audit_token: String?
    @NSManaged public var instigator_process_signing_id: String?
    @NSManaged public var account_type: String?
    @NSManaged public var account_name: String?
    @NSManaged public var node_name: String?
    @NSManaged public var db_path: String?
    @NSManaged public var error_code: Int32
    @NSManaged public var error_code_human: String?

}

extension ESODModifyPasswordEvent : Identifiable {

}
