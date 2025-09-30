//
//  ESTimeSpec+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 3/16/25.
//
//

import Foundation
import CoreData

@objc(ESTimeSpec)
public class ESTimeSpec: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, tv_sec, tv_nsec
    }
    
    // MARK: - Custom initilizer for ESTimeSpec
    convenience init(from spec: TimeSpec) {
        self.init()
        self.id = spec.id
        self.tv_sec = Int64(spec.tv_sec)
        self.tv_nsec = Int64(spec.tv_nsec)
    }
    
    // MARK: - Custom Core Data initilizer for ESTimeSpec
    convenience init(
        from spec: TimeSpec,
        insertIntoManagedObjectContext context: NSManagedObjectContext!
    ) {
        let description = NSEntityDescription.entity(forEntityName: "ESTimeSpec", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = spec.id
        self.tv_sec = Int64(spec.tv_sec)
        self.tv_nsec = Int64(spec.tv_nsec)
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try tv_sec = container.decode(Int64.self, forKey: .tv_sec)
        try tv_nsec = container.decode(Int64.self, forKey: .tv_nsec)
    }
}

// MARK: - Encodable conformance
extension ESTimeSpec: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
        try container.encode(tv_sec, forKey: .tv_sec)
        try container.encode(tv_nsec, forKey: .tv_nsec)
    }
}


