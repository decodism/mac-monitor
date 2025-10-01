//
//  ESUIPCConnectEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 10/1/25.
//
//

import Foundation
import CoreData


extension ESUIPCConnectEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESUIPCConnectEvent> {
        return NSFetchRequest<ESUIPCConnectEvent>(entityName: "ESUIPCConnectEvent")
    }

    @NSManaged public var id: UUID
    @NSManaged public var file: ESFile
    
    @NSManaged public var domain: Int32
    @NSManaged public var type: Int32
    @NSManaged public var `protocol`: Int32
    
    @NSManaged public var type_string: String
    @NSManaged public var domain_string: String
    @NSManaged public var protocol_string: String
   
}

extension ESUIPCConnectEvent : Identifiable {

}
