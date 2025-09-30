//
//  Executable+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 3/9/25.
//
//

import Foundation
import CoreData


extension ESFile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESFile> {
        return NSFetchRequest<ESFile>(entityName: "ESFile")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var path: String?
    @NSManaged public var name: String
    @NSManaged public var path_truncated: Bool
    @NSManaged public var stat: ESStat?

}

extension ESFile : Identifiable {

}
