//
//  ESLinkEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/1/23.
//
//

import Foundation
import CoreData


extension ESLinkEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESLinkEvent> {
        return NSFetchRequest<ESLinkEvent>(entityName: "ESLinkEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var source_file_path: String?
    @NSManaged public var source_file_name: String?
    @NSManaged public var target_file_path: String?
    @NSManaged public var target_file_name: String?

}

extension ESLinkEvent : Identifiable {

}
