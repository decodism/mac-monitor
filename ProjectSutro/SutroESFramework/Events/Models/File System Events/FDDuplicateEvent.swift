//
//  FDDuplicateEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 2/16/23.
//

import Foundation


import Foundation
import EndpointSecurity


// https://developer.apple.com/documentation/endpointsecurity/es_event_dup_t
public struct FDDuplicateEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    public var file_path, file_name: String?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(file_path)
    }
    
    public static func == (lhs: FDDuplicateEvent, rhs: FDDuplicateEvent) -> Bool {
        if lhs.file_path == rhs.file_path {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>, shouldCheckQuarantine: Bool = false) {
        let fileDuplicateEvent: es_event_dup_t = rawMessage.pointee.event.dup
        
        if fileDuplicateEvent.target.pointee.path.data != nil && fileDuplicateEvent.target.pointee.path.length > 0 {
            self.file_path = String(cString: fileDuplicateEvent.target.pointee.path.data)
        } else {
            self.file_path = "UNKNOWN"
        }
        
        self.file_name = URL(filePath: self.file_path!).lastPathComponent
    }
}
