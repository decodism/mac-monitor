//
//  ESThread+CoreDataClass.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 4/18/25.
//
//

import Foundation
import CoreData

@objc(ESThread)
public class ESThread: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case thread_id
    }
    
    convenience init(from thread: SutroESFramework.Thread) {
        self.init()
        self.id = thread.id
        self.thread_id = Int64(thread.thread_id)
    }
    
    convenience init(from thread: SutroESFramework.Thread, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let description = NSEntityDescription.entity(forEntityName: "ESThread", in: context)!
        self.init(entity: description, insertInto: context)
        
        self.id = thread.id
        self.thread_id = Int64(thread.thread_id)
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try thread_id = container.decode(Int64.self, forKey: .thread_id)
    }
    
}

// MARK: - Encodable conformance
extension ESThread: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(thread_id, forKey: .thread_id)
    }
}
