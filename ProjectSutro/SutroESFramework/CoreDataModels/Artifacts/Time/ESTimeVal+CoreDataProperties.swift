//
//  ESTimeVal+CoreDataProperties.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 3/12/25.
//
//

import Foundation
import CoreData


extension ESTimeVal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESTimeVal> {
        return NSFetchRequest<ESTimeVal>(entityName: "ESTimeVal")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var tv_sec: Int64
    @NSManaged public var tv_usec: Int64

}

extension ESTimeVal : Identifiable {

}
