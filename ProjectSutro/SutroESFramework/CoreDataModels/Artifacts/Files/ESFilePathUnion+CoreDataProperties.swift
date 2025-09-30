//
//  ESFilePathUnion+CoreDataProperties.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 8/18/25.
//
//

import Foundation
import CoreData


extension ESFilePathUnion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESFilePathUnion> {
        return NSFetchRequest<ESFilePathUnion>(entityName: "ESFilePathUnion")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var file_path: String?
    @NSManaged public var file: ESFile?

}

extension ESFilePathUnion : Identifiable {

}
