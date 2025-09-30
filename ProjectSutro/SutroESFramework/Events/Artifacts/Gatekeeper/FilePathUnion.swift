//
//  FilePathUnion.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 8/18/25.
//

///
///
/// ```swift
/// union {
///   es_string_token_t file_path;
///   es_file_t *_Nonnull file;
/// } file;```
///
///
///

/// Models the union
public enum FilePathUnion: Hashable, Codable {
    case file_path(String)
    case file(File)
    
    static func from(override: es_event_gatekeeper_user_override_t) -> FilePathUnion {
        switch override.file_type {
        case ES_GATEKEEPER_USER_OVERRIDE_FILE_TYPE_PATH:
            return .file_path(
                String(cString: override.file.file_path.data)
            )
            
        case ES_GATEKEEPER_USER_OVERRIDE_FILE_TYPE_FILE:
            return .file(
                File(from: override.file.file.pointee)
            )
            
        default:
            fatalError("Unhandled override file type \(override.file_type)")
        }
    }
}

/// Accessors
extension FilePathUnion {
    // MARK: Process events
    var file_path: String? {
        if case .file_path(let e) = self { return e }
        return nil
    }
    
    var file: File? {
        if case .file(let e) = self { return e }
        return nil
    }
}
