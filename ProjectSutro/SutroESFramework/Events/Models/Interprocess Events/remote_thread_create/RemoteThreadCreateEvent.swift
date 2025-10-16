//
//  RemoteThreadCreateEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/2/23.
//

import Foundation


// https://developer.apple.com/documentation/endpointsecurity/es_event_remote_thread_create_t
public struct RemoteThreadCreateEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    public var target: Process
    public var thread_state: String?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: RemoteThreadCreateEvent, rhs: RemoteThreadCreateEvent) -> Bool {
        if lhs.target.audit_token_string != rhs.target.audit_token_string {
            return false
        }
        
        if lhs.thread_state != rhs.thread_state {
            return false
        }
        
        return true
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        // Getting the thread create event
        let remoteThreadEvent: es_event_remote_thread_create_t = rawMessage.pointee.event.remote_thread_create
        let version = Int(rawMessage.pointee.version)
        
        self.target = Process(from: remoteThreadEvent.target.pointee, version: version)
        
        if let threadState = remoteThreadEvent.thread_state {
            #if arch(i386)
            switch(threadState.pointee.flavor) {
            case x86_THREAD_STATE32:
                self.thread_state = "x86_THREAD_STATE32"
            case x86_FLOAT_STATE32:
                self.thread_state = "x86_FLOAT_STATE32"
            case x86_EXCEPTION_STATE32:
                self.thread_state = "x86_EXCEPTION_STATE32"
            case x86_DEBUG_STATE32:
                self.thread_state = "x86_DEBUG_STATE32"
            case x86_THREAD_STATE64:
                self.thread_state = "x86_THREAD_STATE64"
            case x86_THREAD_FULL_STATE64:
                self.thread_state = "x86_THREAD_FULL_STATE64"
            case x86_FLOAT_STATE64:
                self.thread_state = "x86_FLOAT_STATE64"
            case x86_EXCEPTION_STATE64:
                self.thread_state = "x86_EXCEPTION_STATE64"
            case x86_DEBUG_STATE64:
                self.thread_state = "x86_DEBUG_STATE64"
            case x86_THREAD_STATE:
                self.thread_state = "x86_THREAD_STATE"
            case x86_FLOAT_STATE:
                self.thread_state = "x86_FLOAT_STATE"
            case x86_EXCEPTION_STATE:
                self.thread_state = "x86_EXCEPTION_STATE"
            case x86_DEBUG_STATE:
                self.thread_state = "x86_DEBUG_STATE"
            case x86_AVX_STATE32:
                self.thread_state = "x86_AVX_STATE32"
            case x86_AVX_STATE64:
                self.thread_state = "x86_THREAD_STATE32"
            case x86_AVX_STATE:
                self.thread_state = "x86_AVX_STATE"
            case x86_AVX512_STATE32:
                self.thread_state = "x86_AVX512_STATE32"
            case x86_AVX512_STATE64:
                self.thread_state = "x86_AVX512_STATE64"
            case x86_AVX512_STATE:
                self.thread_state = "x86_AVX512_STATE"
            case x86_PAGEIN_STATE:
                self.thread_state = "x86_PAGEIN_STATE"
            case x86_INSTRUCTION_STATE:
                self.thread_state = "x86_INSTRUCTION_STATE"
            case x86_LAST_BRANCH_STATE:
                self.thread_state = "x86_LAST_BRANCH_STATE"
            case THREAD_STATE_NONE:
                self.thread_state = "THREAD_STATE_NONE"
            }
            #elseif arch(arm64)
            switch(threadState.pointee.flavor) {
            case ARM_THREAD_STATE:
                self.thread_state = "ARM_THREAD_STATE"
            case ARM_VFP_STATE:
                self.thread_state = "ARM_VFP_STATE"
            case ARM_EXCEPTION_STATE:
                self.thread_state = "ARM_EXCEPTION_STATE"
            case ARM_DEBUG_STATE:
                self.thread_state = "ARM_DEBUG_STATE"
            case THREAD_STATE_NONE:
                self.thread_state = "THREAD_STATE_NONE"
            case ARM_THREAD_STATE32:
                self.thread_state = "ARM_THREAD_STATE32"
            case ARM_THREAD_STATE64:
                self.thread_state = "ARM_THREAD_STATE64"
            case ARM_EXCEPTION_STATE64:
                self.thread_state = "ARM_EXCEPTION_STATE64"
            case ARM_NEON_STATE:
                self.thread_state = "ARM_NEON_STATE"
            case ARM_NEON_STATE64:
                self.thread_state = "ARM_NEON_STATE64"
            case ARM_DEBUG_STATE32:
                self.thread_state = "ARM_DEBUG_STATE32"
            case ARM_DEBUG_STATE64:
                self.thread_state = "ARM_DEBUG_STATE64"
            default:
                break
            }
            #endif
        }
    }
}
