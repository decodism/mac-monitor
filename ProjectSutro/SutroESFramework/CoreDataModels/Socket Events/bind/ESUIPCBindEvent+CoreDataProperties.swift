//
//  ESUIPCBindEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 10/1/25.
//
//

import Foundation
import CoreData



extension ESUIPCBindEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESUIPCBindEvent> {
        return NSFetchRequest<ESUIPCBindEvent>(entityName: "ESUIPCBindEvent")
    }

    @NSManaged public var id: UUID
    @NSManaged public var mode: Int32
    @NSManaged public var filename: String
    @NSManaged public var dir: ESFile

}

extension ESUIPCBindEvent : Identifiable {

}
