//
//  ESAuditToken+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 3/16/25.
//
//

import Foundation
import CoreData


extension ESAuditToken {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESAuditToken> {
        return NSFetchRequest<ESAuditToken>(entityName: "ESAuditToken")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var pid: Int32
    @NSManaged public var ruid: Int64
    @NSManaged public var euid: Int64
    @NSManaged public var rgid: Int64
    @NSManaged public var egid: Int64
    @NSManaged public var asid: Int32
    @NSManaged public var auid: Int64
    @NSManaged public var pidversion: Int32

}

extension ESAuditToken : Identifiable {

}
