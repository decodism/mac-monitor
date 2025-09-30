//
//  ESGetTaskEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/3/23.
//
//

import Foundation
import CoreData


extension ESGetTaskEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESGetTaskEvent> {
        return NSFetchRequest<ESGetTaskEvent>(entityName: "ESGetTaskEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var process_path: String?
    @NSManaged public var process_name: String?
    @NSManaged public var process_audit_token: String?
    @NSManaged public var process_signing_id: String?
    @NSManaged public var type: String?

}

extension ESGetTaskEvent : Identifiable {

}
