//
//  ESFileWriteEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/1/23.
//
//

import Foundation
import CoreData


extension ESFileWriteEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESFileWriteEvent> {
        return NSFetchRequest<ESFileWriteEvent>(entityName: "ESFileWriteEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var file_path: String?
    @NSManaged public var file_name: String?

}

extension ESFileWriteEvent : Identifiable {

}
