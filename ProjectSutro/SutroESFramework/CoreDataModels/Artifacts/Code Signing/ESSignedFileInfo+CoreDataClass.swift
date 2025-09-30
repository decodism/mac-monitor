//
//  ESSignedFileInfo+CoreDataClass.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 8/18/25.
//
//

public import CoreData


@objc(ESSignedFileInfo)
public class ESSignedFileInfo: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case cdhash
        case signing_id
        case team_id
    }
    
    // MARK: - Custom initilizer for ESSignedFileInfo
    convenience init(from singingInfo: SignedFileInfo) {
        self.init()
        self.id = UUID()
        
        cdhash = singingInfo.cdhash
        signing_id = singingInfo.signing_id
        team_id = singingInfo.team_id
    }
    
    // MARK: - Custom Core Data initilizer for ESSignedFileInfo
    convenience init(
        from singingInfo: SignedFileInfo,
        insertIntoManagedObjectContext context: NSManagedObjectContext!
    ) {
        let description = NSEntityDescription.entity(forEntityName: "ESSignedFileInfo", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = UUID()
        
        cdhash = singingInfo.cdhash
        signing_id = singingInfo.signing_id
        team_id = singingInfo.team_id
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try cdhash = container.decode(String.self, forKey: .cdhash)
        try signing_id = container.decode(String.self, forKey: .signing_id)
        try team_id = container.decode(String.self, forKey: .team_id)
    }
}

// MARK: - Encodable conformance and helper
extension ESSignedFileInfo: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        //        try container.encode(id, forKey: .id)
        try container.encode(cdhash, forKey: .cdhash)
        try container.encode(signing_id, forKey: .signing_id)
        try container.encode(team_id, forKey: .team_id)
    }
}
