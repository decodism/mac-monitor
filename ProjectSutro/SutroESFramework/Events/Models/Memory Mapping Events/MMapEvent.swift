//
//  MMapEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/13/23.
//

import Foundation
import EndpointSecurity
import OSLog


// https://developer.apple.com/documentation/endpointsecurity/es_event_mmap_t
public struct MMapEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    public var protection, max_protection, flags: Int32
    public var file_pos: Int
    public var source: File
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(source)
        hasher.combine(file_pos)
    }
    
    public static func == (lhs: MMapEvent, rhs: MMapEvent) -> Bool {
        let lhs_path = lhs.source.path
        let rhs_path = rhs.source.path
        
        if lhs_path != rhs_path {
            return false
        }
        
        if lhs.file_pos != rhs.file_pos {
            return false
        }
        
        return true
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let mmapEvent: es_event_mmap_t = rawMessage.pointee.event.mmap
        
        self.protection = mmapEvent.protection
        self.max_protection = mmapEvent.max_protection
        self.flags = mmapEvent.flags
        self.file_pos = Int(mmapEvent.file_pos)
        self.source = File(from: mmapEvent.source.pointee)
    }
}
