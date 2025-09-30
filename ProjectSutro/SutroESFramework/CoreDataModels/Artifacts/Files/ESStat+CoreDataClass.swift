//
//  Stat+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 3/9/25.
//
//

import Foundation
import CoreData

@objc(ESStat)
public class ESStat: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, st_dev, st_blksize, st_blocks, st_flags, st_gen, st_gid, st_ino, st_mode, st_nlink, st_rdev, st_size, st_uid, st_atimespec, st_birthtimespec, st_ctimespec, st_mtimespec
    }
    
    // MARK: - Custom initializer for Stat
    convenience init(from stat: Stat) {
        self.init()
        self.id = stat.id
        self.st_dev = stat.st_dev
        self.st_blksize = stat.st_blksize
        self.st_blocks = stat.st_blocks
        self.st_flags = stat.st_flags
        self.st_gen = stat.st_gen
        self.st_gid = stat.st_gid
        self.st_ino = stat.st_ino
        self.st_mode = stat.st_mode
        self.st_nlink = stat.st_nlink
        self.st_rdev = stat.st_rdev
        self.st_size = stat.st_size
        self.st_uid = stat.st_uid
        self.st_atimespec = stat.st_atimespec.humanFormat()
        self.st_birthtimespec = stat.st_birthtimespec.humanFormat()
        self.st_ctimespec = stat.st_ctimespec.humanFormat()
        self.st_mtimespec = stat.st_mtimespec.humanFormat()
    }
    
    // MARK: - Custom Core Data initializer for Stat
    convenience init(
        from stat: Stat,
        insertIntoManagedObjectContext context: NSManagedObjectContext!
    ) {
        let description = NSEntityDescription.entity(forEntityName: "ESStat", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = stat.id
        self.st_dev = stat.st_dev
        self.st_blksize = stat.st_blksize
        self.st_blocks = stat.st_blocks
        self.st_flags = stat.st_flags
        self.st_gen = stat.st_gen
        self.st_gid = stat.st_gid
        self.st_ino = stat.st_ino
        self.st_mode = stat.st_mode
        self.st_nlink = stat.st_nlink
        self.st_rdev = stat.st_rdev
        self.st_size = stat.st_size
        self.st_uid = stat.st_uid
        self.st_atimespec = stat.st_atimespec.humanFormat()
        self.st_birthtimespec = stat.st_birthtimespec.humanFormat()
        self.st_ctimespec = stat.st_ctimespec.humanFormat()
        self.st_mtimespec = stat.st_mtimespec.humanFormat()
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        id = try container.decode(UUID.self, forKey: .id)
        st_dev = try container.decode(Int64.self, forKey: .st_dev)
        st_blksize = try container.decode(Int64.self, forKey: .st_blksize)
        st_blocks = try container.decode(Int64.self, forKey: .st_blocks)
        st_flags = try container.decode(Int64.self, forKey: .st_flags)
        st_gen = try container.decode(Int64.self, forKey: .st_gen)
        st_gid = try container.decode(Int64.self, forKey: .st_gid)
        st_ino = try container.decode(Int64.self, forKey: .st_ino)
        st_mode = try container.decode(Int64.self, forKey: .st_mode)
        st_nlink = try container.decode(Int64.self, forKey: .st_nlink)
        st_rdev = try container.decode(Int64.self, forKey: .st_rdev)
        st_size = try container.decode(Int64.self, forKey: .st_size)
        st_uid = try container.decode(Int64.self, forKey: .st_uid)
        st_atimespec = try container.decode(String.self, forKey: .st_atimespec)
        st_birthtimespec = try container.decode(String.self, forKey: .st_birthtimespec)
        st_ctimespec = try container.decode(String.self, forKey: .st_ctimespec)
        st_mtimespec = try container.decode(String.self, forKey: .st_mtimespec)
    }
}

// MARK: - Encodable conformance
extension ESStat: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
//        try container.encode(id, forKey: .id)
        try container.encode(st_dev, forKey: .st_dev)
        try container.encode(st_blksize, forKey: .st_blksize)
        try container.encode(st_blocks, forKey: .st_blocks)
        try container.encode(st_flags, forKey: .st_flags)
        try container.encode(st_gen, forKey: .st_gen)
        try container.encode(st_gid, forKey: .st_gid)
        try container.encode(st_ino, forKey: .st_ino)
        try container.encode(st_mode, forKey: .st_mode)
        try container.encode(st_nlink, forKey: .st_nlink)
        try container.encode(st_rdev, forKey: .st_rdev)
        try container.encode(st_size, forKey: .st_size)
        try container.encode(st_uid, forKey: .st_uid)
        try container.encode(st_atimespec, forKey: .st_atimespec)
        try container.encode(st_birthtimespec, forKey: .st_birthtimespec)
        try container.encode(st_ctimespec, forKey: .st_ctimespec)
        try container.encode(st_mtimespec, forKey: .st_mtimespec)
    }
}
