//
//  ESFileRenameEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 2/17/23.
//
//

import Foundation
import CoreData


extension ESFileRenameEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESFileRenameEvent> {
        return NSFetchRequest<ESFileRenameEvent>(entityName: "ESFileRenameEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var source: ESFile
    @NSManaged public var destination_type: Int16
    @NSManaged public var destination_type_string: String
    @NSManaged public var destination: ESFileDestination
    
    /// @note Mac Monitor enrichment
    @NSManaged public var destination_path: String
    @NSManaged public var is_quarantined: Int16

}

extension ESFileRenameEvent : Identifiable {

}
