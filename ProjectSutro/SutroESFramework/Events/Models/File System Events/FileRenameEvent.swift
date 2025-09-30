//
//  FileRenameEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 2/17/23.
//

import Foundation
import EndpointSecurity
import OSLog


// https://developer.apple.com/documentation/endpointsecurity/es_event_rename_t
public struct FileRenameEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    public var source: File
    
    public var destination_type: Int
    public var destination_type_string: String
    public var destination: FileDestination
    
    /// @note Mac Monitor enrichment
    public var destination_path: String = ""
    public var is_quarantined: Int16 = 0
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: FileRenameEvent, rhs: FileRenameEvent) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        
        return false
    }
    
    // @note files_not_quarantined should be a list of sub paths
    init(from rawMessage: UnsafePointer<es_message_t>, files_not_quarantined: [String] = []) {
        let fileRenameEvent: es_event_rename_t = rawMessage.pointee.event.rename
        
        self.source = File(from: fileRenameEvent.source.pointee)
        self.destination_type = Int(fileRenameEvent.destination_type.rawValue)
        self.destination = FileDestination.from(rename: fileRenameEvent)
        
        switch(fileRenameEvent.destination_type) {
        case ES_DESTINATION_TYPE_EXISTING_FILE:
            self.destination_type_string = "ES_DESTINATION_TYPE_EXISTING_FILE"
            
            if let path = destination.existing_file?.path {
                self.destination_path = path
                self.is_quarantined = Int16(ProcessHelpers.isFileQuarantined(filePath: path))
            }
        case ES_DESTINATION_TYPE_NEW_PATH:
            self.destination_type_string = "ES_DESTINATION_TYPE_NEW_PATH"
            
            if let dir = destination.new_path?.dir.path,
               let fileName = destination.new_path?.filename {
                self.destination_path = "\(dir)/\(fileName)"
                self.is_quarantined = Int16(ProcessHelpers.isFileQuarantined(filePath: self.destination_path))
            }
        default:
            self.destination_type_string = "NOT_MAPPED"
        }
    }
}
