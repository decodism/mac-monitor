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

    @NSManaged public var id: UUID
    
    @NSManaged public var instigator: ESProcess?
    @NSManaged public var petitioner: ESProcess?
    @NSManaged public var resultsData: Data?
    @NSManaged public var return_code: Int32
    @NSManaged public var result_count: Int32
    
    @NSManaged public var instigator_token: ESAuditToken?
    @NSManaged public var petitioner_token: ESAuditToken?

}

extension ESAuthorizationJudgementEvent : Identifiable {

}
