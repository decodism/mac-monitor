//
//  ESFileOpenEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/1/23.
//
//

import Foundation
import CoreData


extension ESFileOpenEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESFileOpenEvent> {
        return NSFetchRequest<ESFileOpenEvent>(entityName: "ESFileOpenEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var file_path: String?
    @NSManaged public var file_name: String?

}

extension ESFileOpenEvent : Identifiable {

}
