//
//  LinkEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/1/23.
//

import Foundation
import EndpointSecurity

// https://developer.apple.com/documentation/endpointsecurity/es_event_link_t
public struct LinkEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    public var source_file_name, source_file_path, target_file_name, target_file_path: String?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(source_file_path)
        hasher.combine(target_file_path)
        hasher.combine(id)
    }
    
    public static func == (lhs: LinkEvent, rhs: LinkEvent) -> Bool {
        if lhs.source_file_path == rhs.source_file_path && lhs.target_file_path == rhs.target_file_path {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        // Getting the file write event
        let linkEvent: es_event_link_t = rawMessage.pointee.event.link
        
        self.source_file_path = ""
        self.source_file_name = ""
        if linkEvent.source.pointee.path.length > 0 {
            self.source_file_path = String(cString: linkEvent.source.pointee.path.data)
            self.source_file_name = (String(cString: linkEvent.source.pointee.path.data) as NSString).lastPathComponent
        }
        
        self.target_file_path = ""
        if linkEvent.target_dir.pointee.path.length > 0 {
            self.target_file_path = String(cString: linkEvent.target_dir.pointee.path.data)
        }
        
        self.target_file_name = ""
        if linkEvent.target_filename.length > 0 {
            self.target_file_name = String(cString: linkEvent.target_filename.data)
            self.target_file_path = String((URL(string: self.target_file_path!)?.appending(path: self.target_file_name!).absoluteString.trimmingPrefix("file://"))!)
        }
        
    }
}
