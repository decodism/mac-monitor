//
//  ESAuthResult+CoreDataProperties.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 5/1/25.
//
//

import Foundation
import CoreData


extension ESAuthResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESAuthResult> {
        return NSFetchRequest<ESAuthResult>(entityName: "ESAuthResult")
    }
    
    @NSManaged public var id: UUID
    // When the action result is `AUTH`
    @NSManaged public var auth: Int64
    @NSManaged public var auth_human: String?
    // When the action result is `FLAGS`
    @NSManaged public var flags: Int64
    
}

extension ESAuthResult : Identifiable {

}
