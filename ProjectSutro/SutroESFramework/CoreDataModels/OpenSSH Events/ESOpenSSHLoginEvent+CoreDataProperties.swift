//
//  ESOpenSSHLoginEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 12/14/22.
//
//

import Foundation
import CoreData


extension ESOpenSSHLoginEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESOpenSSHLoginEvent> {
        return NSFetchRequest<ESOpenSSHLoginEvent>(entityName: "ESOpenSSHLoginEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var result_type: String?
    @NSManaged public var source_address: String?
    @NSManaged public var source_address_type: String?
    @NSManaged public var success: Bool
    @NSManaged public var user_name: String?

}

extension ESOpenSSHLoginEvent : Identifiable {

}
