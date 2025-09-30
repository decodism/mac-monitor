//
//  SignedFileInfo.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 8/18/25.
//


// Ensure SignedFileInfo conforms to Codable and Equatable
public struct SignedFileInfo: Identifiable, Codable, Equatable, Hashable {
    public var id = UUID()
    
    public var cdhash, signing_id, team_id: String
    
    // Ignore id from being decoded
    enum CodingKeys: String, CodingKey {
        case cdhash, signing_id, team_id
    }
    
    public init(from signing_info: es_signed_file_info_t) {
        cdhash = cdhashToString(cdhash: signing_info.cdhash)
        if signing_info.signing_id.length > 0 {
            signing_id = String(cString: signing_info.signing_id.data)
        } else {
            signing_id = ""
        }
        
        if signing_info.team_id.length > 0 {
            team_id = String(cString: signing_info.team_id.data)
        } else {
            team_id = ""
        }
    }
}
