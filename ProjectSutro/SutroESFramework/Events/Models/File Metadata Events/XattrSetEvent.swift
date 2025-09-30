//
//  XattrSetEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/3/23.
//

import Foundation
import EndpointSecurity


// https://developer.apple.com/documentation/endpointsecurity/3228936-es_events_t/3228954-setextattr
public struct XattrSetEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    public var file_name, file_path, xattr: String?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(file_path)
        hasher.combine(xattr)
        hasher.combine(id)
    }
    
    public static func == (lhs: XattrSetEvent, rhs: XattrSetEvent) -> Bool {
        if lhs.file_path == rhs.file_path && lhs.xattr == rhs.xattr && lhs.id == rhs.id {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        // Getting the extended attribute (xattr) set event
        let xattrSetEvent: es_event_setextattr_t = rawMessage.pointee.event.setextattr
        self.file_path = String(cString: xattrSetEvent.target.pointee.path.data)
        self.file_name = NSURL(fileURLWithPath: String(cString: xattrSetEvent.target.pointee.path.data)).lastPathComponent
        self.xattr = String(cString: xattrSetEvent.extattr.data)
    }
}
