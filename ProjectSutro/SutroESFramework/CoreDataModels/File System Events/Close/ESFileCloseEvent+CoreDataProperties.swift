//
//  ESFileCloseEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/2/23.
//
//

import Foundation
import CoreData


extension ESFileCloseEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESFileCloseEvent> {
        return NSFetchRequest<ESFileCloseEvent>(entityName: "ESFileCloseEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var file_path: String?
    @NSManaged public var file_name: String?

}

extension ESFileCloseEvent : Identifiable {

}
