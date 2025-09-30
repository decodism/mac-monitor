//
//  ESThread+CoreDataProperties.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 4/18/25.
//
//

import Foundation
import CoreData


extension ESThread {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESThread> {
        return NSFetchRequest<ESThread>(entityName: "ESThread")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var thread_id: Int64

}

extension ESThread : Identifiable {

}
