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

    @NSManaged public var id: UUID
    
    @NSManaged public var success: Bool
    @NSManaged public var result_type: Int32
    @NSManaged public var result_type_string: String
    
    @NSManaged public var source_address_type: Int32
    @NSManaged public var source_address_type_string: String
    
    @NSManaged public var source_address: String
    @NSManaged public var username: String
    
    @NSManaged public var has_uid: Bool
    @NSManaged public var uid: Int32

}

extension ESOpenSSHLoginEvent : Identifiable {

}
