//
//  ESXPCConnectEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 6/24/23.
//
//

import Foundation
import CoreData


extension ESXPCConnectEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESXPCConnectEvent> {
        return NSFetchRequest<ESXPCConnectEvent>(entityName: "ESXPCConnectEvent")
    }

    @NSManaged public var id: UUID
    @NSManaged public var service_name: String
    @NSManaged public var service_domain_type: Int32
    @NSManaged public var service_domain_type_string: String
    
}

extension ESXPCConnectEvent : Identifiable {

}
