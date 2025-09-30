//
//  ESOpenSSHLogoutEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/13/23.
//
//

import Foundation
import CoreData


extension ESOpenSSHLogoutEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESOpenSSHLogoutEvent> {
        return NSFetchRequest<ESOpenSSHLogoutEvent>(entityName: "ESOpenSSHLogoutEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var source_address_type: String?
    @NSManaged public var source_address: String?
    @NSManaged public var username: String?

}

extension ESOpenSSHLogoutEvent : Identifiable {

}
