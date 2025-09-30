//
//  MountEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/17/23.
//

import Foundation
import EndpointSecurity
import OSLog

func charPointerToString(_ pointer: UnsafePointer<Int8>) -> String {
   return String(cString: UnsafeRawPointer(pointer).assumingMemoryBound(to: CChar.self))
}


// https://developer.apple.com/documentation/endpointsecurity/es_event_mount_t
public struct MountEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    public var mount_flags, owner_uid, total_files: Int64
    public var mount_directory, source_name, type_name, fs_id, owner_uid_human: String
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(mount_directory)
        hasher.combine(owner_uid)
        hasher.combine(type_name)
        hasher.combine(fs_id)
    }
    
    public static func == (lhs: MountEvent, rhs: MountEvent) -> Bool {
        if lhs.mount_directory == rhs.mount_directory && lhs.total_files == rhs.total_files && lhs.fs_id == rhs.fs_id {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let mountEvent: es_event_mount_t = rawMessage.pointee.event.mount
        
        self.mount_flags = Int64(mountEvent.statfs.pointee.f_flags)
        self.owner_uid = Int64(mountEvent.statfs.pointee.f_owner)
        self.total_files = Int64(mountEvent.statfs.pointee.f_files)
        
        self.mount_directory = charPointerToString(&mountEvent.statfs.pointee.f_mntonname.0)
        self.source_name = charPointerToString(&mountEvent.statfs.pointee.f_mntfromname.0)
        self.type_name = charPointerToString(&mountEvent.statfs.pointee.f_fstypename.0)
        
        self.fs_id = "\(mountEvent.statfs.pointee.f_fsid.val.0) \(mountEvent.statfs.pointee.f_fsid.val.1)"
        self.owner_uid_human = String(cString: getpwuid(uid_t(mountEvent.statfs.pointee.f_owner))!.pointee.pw_name)
    }
}
