//
//  XattrEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/13/23.
//

import Foundation
import EndpointSecurity


// https://developer.apple.com/documentation/endpointsecurity/es_event_deleteextattr_t
public struct XattrDeleteEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    public var file_name, file_path, xattr: String?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(file_path)
        hasher.combine(xattr)
        hasher.combine(id)
    }
    
    public static func == (lhs: XattrDeleteEvent, rhs: XattrDeleteEvent) -> Bool {
        if lhs.file_path == rhs.file_path && lhs.xattr == rhs.xattr && lhs.id == rhs.id {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        // Getting the extended attribute (xattr) delete event
        let xattrDeleteEvent: es_event_deleteextattr_t = rawMessage.pointee.event.deleteextattr
        self.file_path = String(cString: xattrDeleteEvent.target.pointee.path.data)
        self.file_name = NSURL(fileURLWithPath: String(cString: xattrDeleteEvent.target.pointee.path.data)).lastPathComponent
        self.xattr = String(cString: xattrDeleteEvent.extattr.data)
    }
}
