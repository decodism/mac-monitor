//
//  FileDeleteEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/1/23.
//

import Foundation
import EndpointSecurity


/// Models an `es_event_unlink_t` event: https://developer.apple.com/documentation/endpointsecurity/es_event_unlink_t
public struct FileDeleteEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    public var parent_directory, file_path, file_name: String?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(parent_directory)
        hasher.combine(file_path)
    }
    
    public static func == (lhs: FileDeleteEvent, rhs: FileDeleteEvent) -> Bool {
        if lhs.file_path == rhs.file_path && lhs.parent_directory == rhs.parent_directory {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let fileDeleteEvent: es_event_unlink_t = rawMessage.pointee.event.unlink
        self.parent_directory = ""
        self.file_path = ""
        self.file_name = ""
        
        if fileDeleteEvent.parent_dir.pointee.path.length > 0 {
            self.parent_directory = String(cString: fileDeleteEvent.parent_dir.pointee.path.data)
        }
        if fileDeleteEvent.target.pointee.path.length > 0 {
            self.file_path = String(cString: fileDeleteEvent.target.pointee.path.data)
            self.file_name = (String(cString: fileDeleteEvent.target.pointee.path.data) as NSString).lastPathComponent
        }
    }
}
