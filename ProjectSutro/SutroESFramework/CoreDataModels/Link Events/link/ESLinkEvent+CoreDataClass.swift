//
//  ESLinkEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/1/23.
//
//

import Foundation
import CoreData

@objc(ESLinkEvent)
public class ESLinkEvent: NSManagedObject {
    enum CodingKeys: CodingKey {
        case id
        case source
        case target_dir
        case target_filename
    }
    
    // MARK: - Custom Core Data initilizer for ESLinkEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let event: LinkEvent = message.event.link!
        let description = NSEntityDescription.entity(forEntityName: "ESLinkEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = event.id
        
        self.source = ESFile(
            from: event.source,
            insertIntoManagedObjectContext: context
        )
        self.target_dir = ESFile(
            from: event.target_dir,
            insertIntoManagedObjectContext: context
        )
        self.target_filename = event.target_filename
    }
}

// MARK: - Encodable conformance
extension ESLinkEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(source, forKey: .source)
        try container.encode(target_dir, forKey: .target_dir)
        try container.encode(target_filename, forKey: .target_filename)
    }
}
