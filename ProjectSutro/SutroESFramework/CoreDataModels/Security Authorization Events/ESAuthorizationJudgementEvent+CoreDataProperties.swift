//
//  ESAuthorizationJudgementEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 6/28/23.
//
//

import Foundation
import CoreData


extension ESAuthorizationJudgementEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESAuthorizationJudgementEvent> {
        return NSFetchRequest<ESAuthorizationJudgementEvent>(entityName: "ESAuthorizationJudgementEvent")
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
    @NSManaged public var return_code: Int32
    @NSManaged public var result_count: Int32
    @NSManaged public var results: String?

}

extension ESAuthorizationJudgementEvent : Identifiable {

}
