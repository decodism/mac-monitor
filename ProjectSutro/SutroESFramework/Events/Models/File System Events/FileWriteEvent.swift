//
//  FileWriteEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/1/23.
//

import Foundation
import EndpointSecurity

// https://developer.apple.com/documentation/endpointsecurity/es_event_write_t
public struct FileWriteEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    public var file_name, file_path: String?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(file_path)
        hasher.combine(file_name)
        hasher.combine(id)
    }
    
    public static func == (lhs: FileWriteEvent, rhs: FileWriteEvent) -> Bool {
        if lhs.file_path == rhs.file_path && lhs.id == rhs.id {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        // Getting the file write event
        let fileWriteEvent: es_event_write_t = rawMessage.pointee.event.write
        self.file_path = String(cString: fileWriteEvent.target.pointee.path.data)
        self.file_name = (String(cString: fileWriteEvent.target.pointee.path.data) as NSString).lastPathComponent
    }
}
