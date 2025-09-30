//
//  Stat+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 3/9/25.
//
//

import Foundation
import CoreData


extension ESStat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESStat> {
        return NSFetchRequest<ESStat>(entityName: "ESStat")
    }

    @NSManaged public var st_dev: Int64
    @NSManaged public var st_blksize: Int64
    @NSManaged public var st_mode: Int64
    @NSManaged public var st_nlink: Int64
    @NSManaged public var st_uid: Int64
    @NSManaged public var st_rdev: Int64
    @NSManaged public var st_gid: Int64
    @NSManaged public var st_size: Int64
    @NSManaged public var st_ino: Int64
    @NSManaged public var st_flags: Int64
    @NSManaged public var st_gen: Int64
    @NSManaged public var st_blocks: Int64
    @NSManaged public var st_atimespec: String?
    @NSManaged public var st_birthtimespec: String?
    @NSManaged public var st_ctimespec: String?
    @NSManaged public var st_mtimespec: String?
    @NSManaged public var id: UUID?

}

extension ESStat : Identifiable {

}
