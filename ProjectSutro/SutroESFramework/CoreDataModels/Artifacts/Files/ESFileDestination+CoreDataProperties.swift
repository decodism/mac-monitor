//
//  ESFileDestination+CoreDataProperties.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 6/27/25.
//
//

public import Foundation
public import CoreData


extension ESFileDestination {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESFileDestination> {
        return NSFetchRequest<ESFileDestination>(entityName: "ESFileDestination")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var existing_file: ESFile?
    @NSManaged public var new_path: ESNewPath?

}

extension ESFileDestination : Identifiable {

}

