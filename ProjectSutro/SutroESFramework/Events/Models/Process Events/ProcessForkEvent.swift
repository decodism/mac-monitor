//
//  ProcessForkEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/13/23.
//

import Foundation
import EndpointSecurity
import OSLog



// MARK: - Process Fork Event https://developer.apple.com/documentation/endpointsecurity/es_event_fork_t
public struct ProcessForkEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    public var child: Process
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(child.executable!.path)
        hasher.combine(child.signing_id)
        hasher.combine(child.pid)
    }
    
    public static func == (lhs: ProcessForkEvent, rhs: ProcessForkEvent) -> Bool {
        if lhs.child.executable!.path == rhs.child.executable!.path && lhs.child.pid == rhs.child.pid && lhs.child.start_time == rhs.child.start_time {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let forkEvent: es_event_fork_t = rawMessage.pointee.event.fork
        
        self.child = Process(from: forkEvent.child.pointee, version: Int(rawMessage.pointee.version))
    }
}
