//
//  ESFileOpenEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/1/23.
//
//

import Foundation
import CoreData

@objc(ESFileOpenEvent)
public class ESFileOpenEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, file, fflag
    }
    
    
    convenience init(from message: Message) {
        let fileEvent: FileOpenEvent = message.event.open!
        self.init()
        self.id = fileEvent.id
        
        self.file = ESFile(from: fileEvent.file)
        self.fflag = fileEvent.fflag
    }
    
    // MARK: - Custom Core Data initilizer for ESFileOpenEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let fileEvent: FileOpenEvent = message.event.open!
        let description = NSEntityDescription.entity(forEntityName: "ESFileOpenEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = fileEvent.id
        
        self.file = ESFile(from: fileEvent.file, insertIntoManagedObjectContext: context)
        self.fflag = fileEvent.fflag
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try file = container.decode(ESFile.self, forKey: .file)
        try fflag = container.decode(Int32.self, forKey: .fflag)
    }
}

// MARK: - Encodable conformance
extension ESFileOpenEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(file, forKey: .file)
        try container.encode(fflag, forKey: .fflag)
    }
}
