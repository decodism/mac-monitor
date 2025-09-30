//
//  ESTimeSpec+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 3/16/25.
//
//

import Foundation
import CoreData


extension ESTimeSpec {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESTimeSpec> {
        return NSFetchRequest<ESTimeSpec>(entityName: "ESTimeSpec")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var tv_sec: Int64
    @NSManaged public var tv_nsec: Int64

}

extension ESTimeSpec : Identifiable {

}
