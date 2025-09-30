//
//  ESFileRenameEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 2/17/23.
//
//

import Foundation
import CoreData
import OSLog

@objc(ESFileRenameEvent)
public class ESFileRenameEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case source
        case destination_type, destination_type_string
        case destination, destination_path
        case is_quarantined
    }
    
    // MARK: - Custom initilizer for ESFileRenameEvent during heavy flows
    convenience init(from message: Message) {
        let fileRenameEvent: FileRenameEvent = message.event.rename!
        self.init()
        self.id = fileRenameEvent.id
        
        self.source = ESFile(from: fileRenameEvent.source)
        
        self.destination_type = Int16(fileRenameEvent.destination_type)
        self.destination_type_string = fileRenameEvent.destination_type_string
        self.destination = ESFileDestination(from: fileRenameEvent.destination)
        
        self.destination_path = fileRenameEvent.destination_path
        self.is_quarantined = fileRenameEvent.is_quarantined
    }
    
    // MARK: - Custom Core Data initilizer for ESFileRenameEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let fileRenameEvent: FileRenameEvent = message.event.rename!
        let description = NSEntityDescription.entity(forEntityName: "ESFileRenameEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = fileRenameEvent.id
        
        self.source = ESFile(from: fileRenameEvent.source, insertIntoManagedObjectContext: context)
        
        self.destination_type = Int16(fileRenameEvent.destination_type)
        self.destination_type_string = fileRenameEvent.destination_type_string
        self.destination = ESFileDestination(from: fileRenameEvent.destination, insertIntoManagedObjectContext: context)
        self.destination_path = fileRenameEvent.destination_path
        
        self.is_quarantined = fileRenameEvent.is_quarantined
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        try id = container.decode(UUID.self, forKey: .id)
        
        try source = container.decode(ESFile.self, forKey: .source)
        try destination_type = container.decode(Int16.self, forKey: .destination_type)
        try destination_type_string = container.decode(String.self, forKey: .destination_type_string)
        try destination = container.decode(ESFileDestination.self, forKey: .destination)
        
        try destination_path = container.decode(String.self, forKey: .destination_path)
        try is_quarantined = container.decode(Int16.self, forKey: .is_quarantined)
    }
}

// MARK: - Encodable conformance
extension ESFileRenameEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
        
        try container.encode(source, forKey: .source)
        try container.encode(destination_type, forKey: .destination_type)
        try container.encode(destination_type_string, forKey: .destination_type_string)
        try container.encode(destination, forKey: .destination)
        
        try container.encode(destination_path, forKey: .destination_path)
        try container.encode(is_quarantined, forKey: .is_quarantined)
        
    }
    
    public var destination_file_name: String {
        URL(fileURLWithPath: destination_path).lastPathComponent
    }
}
