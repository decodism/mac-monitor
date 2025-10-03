//
//  ESTimeVal+CoreDataClass.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 3/12/25.
//
//

import Foundation
import CoreData

@objc(ESTimeVal)
public class ESTimeVal: NSManagedObject {
    enum CodingKeys: CodingKey {
        case id, tv_sec, tv_usec
    }
    
    // MARK: - Custom Core Data initilizer for TimeVal
    convenience init(
        from time: TimeVal,
        insertIntoManagedObjectContext context: NSManagedObjectContext!
    ) {
        let description = NSEntityDescription.entity(forEntityName: "ESTimeVal", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = time.id
        
        self.tv_sec = Int64(time.tv_sec)
        self.tv_usec = Int64(time.tv_usec)
    }
}

// MARK: - Encodable conformance
extension ESTimeVal: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
        try container.encode(tv_sec, forKey: .tv_sec)
        try container.encode(tv_usec, forKey: .tv_usec)
    }
}

