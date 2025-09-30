//
//  FileCloseEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/2/23.
//

import Foundation
import EndpointSecurity

// https://developer.apple.com/documentation/endpointsecurity/es_event_close_t
public struct FileCloseEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    public var file_name, file_path: String?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(file_path)
        hasher.combine(id)
    }
    
    public static func == (lhs: FileCloseEvent, rhs: FileCloseEvent) -> Bool {
        if lhs.file_path == rhs.file_path && lhs.id == rhs.id {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        // Getting the file write event
        let closeEvent: es_event_close_t = rawMessage.pointee.event.close
        
        self.file_path = ""
        self.file_name = ""
        if closeEvent.target.pointee.path.length > 0 {
            self.file_path = String(cString: closeEvent.target.pointee.path.data)
            self.file_name = (String(cString: closeEvent.target.pointee.path.data) as NSString).lastPathComponent
        }
    }
}
