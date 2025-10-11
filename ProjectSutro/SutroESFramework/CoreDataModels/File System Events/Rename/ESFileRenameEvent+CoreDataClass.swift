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
        case id, destination_path, file_name, type, source_path, archive_files_not_quarantined, is_quarantined
    }
    
    // MARK: - Custom initilizer for ESFileRenameEvent during heavy flows
    convenience init(from message: Message) {
        let fileRenameEvent: FileRenameEvent = message.event.rename!
        self.init()
        self.id = fileRenameEvent.id
        self.file_name = fileRenameEvent.file_name ?? "UNKNOWN"
        self.destination_path = fileRenameEvent.destination_path ?? "UNKNOWN"
        self.source_path = fileRenameEvent.source_path ?? "UNKNOWN"
        self.type = fileRenameEvent.type ?? "UNKNOWN"
        self.archive_files_not_quarantined = fileRenameEvent.archive_files_not_quarantined ?? ""
        self.is_quarantined = fileRenameEvent.is_quarantined
    }
    
    // MARK: - Custom Core Data initilizer for ESFileRenameEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let fileRenameEvent: FileRenameEvent = message.event.rename!
        let description = NSEntityDescription.entity(forEntityName: "ESFileRenameEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = fileRenameEvent.id
        self.file_name = fileRenameEvent.file_name ?? "UNKNOWN"
        self.destination_path = fileRenameEvent.destination_path ?? "UNKNOWN"
        self.source_path = fileRenameEvent.source_path ?? "UNKNOWN"
        self.type = fileRenameEvent.type ?? "UNKNOWN"
        self.archive_files_not_quarantined = fileRenameEvent.archive_files_not_quarantined ?? ""
        self.is_quarantined = fileRenameEvent.is_quarantined
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try destination_path = container.decode(String.self, forKey: .destination_path)
        try file_name = container.decode(String.self, forKey: .file_name)
        try type = container.decode(String.self, forKey: .type)
        try source_path = container.decode(String.self, forKey: .source_path)
        try archive_files_not_quarantined = container.decode(String.self, forKey: .archive_files_not_quarantined)
        try is_quarantined = container.decode(Int16.self, forKey: .is_quarantined)
    }
}

// MARK: - Encodable conformance
extension ESFileRenameEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
        try container.encode(destination_path, forKey: .destination_path)
        try container.encode(file_name, forKey: .file_name)
        try container.encode(type, forKey: .type)
        try container.encode(source_path, forKey: .source_path)
        if let archiveFiles = self.archive_files_not_quarantined, !archiveFiles.isEmpty {
            try container.encode(archiveFiles, forKey: .archive_files_not_quarantined)
        }
        try container.encode(is_quarantined, forKey: .is_quarantined)
        
    }
}
