//
//  ESFilePathUnion+CoreDataClass.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 8/18/25.
//
//

public import CoreData


@objc(ESFilePathUnion)
public class ESFilePathUnion: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case file_path
        case file
    }
    
    // MARK: - Custom initilizer for ESFilePathUnion
    convenience init(from filePathUnion: FilePathUnion) {
        self.init()
        self.id = UUID()
        
        self.file_path = filePathUnion.file_path
        if let file = filePathUnion.file {
            self.file = ESFile(from: file)
        }
    }
    
    // MARK: - Custom Core Data initilizer for FilePathUnion
    convenience init(
        from filePathUnion: FilePathUnion,
        insertIntoManagedObjectContext context: NSManagedObjectContext!
    ) {
        let description = NSEntityDescription.entity(forEntityName: "ESFilePathUnion", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = UUID()
        
        self.file_path = filePathUnion.file_path
        if let file = filePathUnion.file {
            self.file = ESFile(
                from: file,
                insertIntoManagedObjectContext: context
            )
        }
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try file_path = container.decodeIfPresent(String.self, forKey: .file_path)
        try file = container.decodeIfPresent(ESFile.self, forKey: .file)
    }
}

// MARK: - Encodable conformance and helper
extension ESFilePathUnion: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        //        try container.encode(id, forKey: .id)
        try container.encode(file_path, forKey: .file_path)
        try container.encode(file, forKey: .file)
    }
}
