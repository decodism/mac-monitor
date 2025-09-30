//
//  FileOpenEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/1/23.
//

import Foundation
import EndpointSecurity


// https://developer.apple.com/documentation/endpointsecurity/es_event_open_t
public struct FileOpenEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    public var file: File
    public var fflag: Int32
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: FileOpenEvent, rhs: FileOpenEvent) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        // Getting the file open event
        let fileOpenEvent: es_event_open_t = rawMessage.pointee.event.open
        self.file = File(from: fileOpenEvent.file.pointee)
        self.fflag = fileOpenEvent.fflag
    }
}
