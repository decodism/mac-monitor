//
//  ESFileDestination+CoreDataClass.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 6/27/25.
//
//

public import CoreData


@objc(ESFileDestination)
public class ESFileDestination: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case existing_file
        case new_path
    }
    
    // MARK: - Custom initilizer for ESFileDestination
    convenience init(from destination: FileDestination) {
        self.init()
        self.id = UUID()
        
        switch destination {
        case .existing_file(let existingFile):
            self.existing_file = ESFile(from: existingFile)
        case .new_path(let newPath):
            self.new_path = ESNewPath(from: newPath)
        }
    }
    
    // MARK: - Custom Core Data initilizer for ESFileDestination
    convenience init(
        from destination: FileDestination,
        insertIntoManagedObjectContext context: NSManagedObjectContext!
    ) {
        let description = NSEntityDescription.entity(forEntityName: "ESFileDestination", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = UUID()
        
        switch destination {
        case .existing_file(let existingFile):
            self.existing_file = ESFile(from: existingFile, insertIntoManagedObjectContext: context)
        case .new_path(let newPath):
            self.new_path = ESNewPath(from: newPath, insertIntoManagedObjectContext: context)
        }
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try existing_file = container.decodeIfPresent(ESFile.self, forKey: .existing_file)
        try new_path = container.decodeIfPresent(ESNewPath.self, forKey: .new_path)
    }
}

// MARK: - Encodable conformance
extension ESFileDestination: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(existing_file, forKey: .existing_file)
        try container.encodeIfPresent(new_path, forKey: .new_path)
    }
}
