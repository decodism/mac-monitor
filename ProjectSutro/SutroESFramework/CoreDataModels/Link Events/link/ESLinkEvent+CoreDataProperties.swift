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

    @NSManaged public var id: UUID
    @NSManaged public var source: ESFile
    @NSManaged public var target_dir: ESFile
    @NSManaged public var target_filename: String

}

extension ESLinkEvent : Identifiable {

}
