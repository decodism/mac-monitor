//
//  ESNewPath+CoreDataClass.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 6/27/25.
//
//

public import CoreData


@objc(ESNewPath)
public class ESNewPath: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case dir
        case filename
        case mode
    }
    
    // MARK: - Custom initilizer for ESNewPath
    convenience init(from newPath: NewPath) {
        self.init()
        self.id = newPath.id
        
        self.dir = ESFile(from: newPath.dir)
        self.filename = newPath.filename
        if let mode = newPath.mode {
            self.mode = Int32(mode)
        }
    }
    
    // MARK: - Custom Core Data initilizer for ESNewPath
    convenience init(
        from newPath: NewPath,
        insertIntoManagedObjectContext context: NSManagedObjectContext!
    ) {
        let description = NSEntityDescription.entity(forEntityName: "ESNewPath", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = newPath.id
        
        self.dir = ESFile(from: newPath.dir, insertIntoManagedObjectContext: context)
        self.filename = newPath.filename
        if let mode = newPath.mode {
            self.mode = Int32(mode)
        }
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try dir = container.decode(ESFile.self, forKey: .dir)
        try filename = container.decode(String.self, forKey: .filename)
        try mode = container.decode(Int32.self, forKey: .mode)
    }
}

// MARK: - Encodable conformance and helper
extension ESNewPath: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        //        try container.encode(id, forKey: .id)
        try container.encode(dir, forKey: .dir)
        try container.encode(filename, forKey: .filename)
        try container.encodeIfPresent(mode, forKey: .mode)
    }
    
//    public var path: String {
//        if let dir = self.dir,
//           let dirPath = dir.path,
//           let filename = self.filename {
//            let path = "\(dirPath)/\(filename)"
//            return path
//        }
//        return ""
//    }
}
