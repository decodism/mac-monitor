//
//  Executable+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 3/9/25.
//
//

import Foundation
import CoreData



@objc(ESFile)
public class ESFile: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, path, path_truncated, stat, name
    }
    
    // MARK: - Custom initilizer for File
    convenience init(from file: File) {
        self.init()
        self.id = file.id
        self.path = file.path
        self.name = file.name
        self.path_truncated = file.path_truncated
        self.stat = ESStat(from: file.stat)
    }
    
    // MARK: - Custom Core Data initilizer for File
    convenience init(
        from file: File,
        insertIntoManagedObjectContext context: NSManagedObjectContext!
    ) {
        let description = NSEntityDescription.entity(forEntityName: "ESFile", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = file.id
        self.path = file.path
        self.name = file.name
        self.path_truncated = file.path_truncated
        self.stat = ESStat(
            from: file.stat,
            insertIntoManagedObjectContext: context
        )
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try path = container.decode(String.self, forKey: .path)
        try path = container.decode(String.self, forKey: .name)
        try stat = container.decode(ESStat.self, forKey: .stat)
        try path_truncated = container.decode(Bool.self, forKey: .path_truncated)
    }

}

// MARK: - Encodable conformance
extension ESFile: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
        try container.encode(path, forKey: .path)
        try container.encode(name, forKey: .name)
        try container.encode(stat, forKey: .stat)
        try container.encode(path_truncated, forKey: .path_truncated)
    }
}
