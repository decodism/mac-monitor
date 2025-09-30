//
//  Thread.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/7/25.
//

import Foundation

/// Models an `es_thread_t` for a ``Message``
public struct Thread: Identifiable, Codable, Equatable, Hashable {
    public var id = UUID()
    
    public var thread_id: Int
    
    public init(from thread: UnsafeMutablePointer<es_thread_t>?) {
        if let thread = thread {
            self.thread_id = Int(thread.pointee.thread_id)
        } else {
            self.thread_id = 0
        }
    }
}
