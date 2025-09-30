//
//  ESMessage+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 11/14/22.
//
//
// References:
// - Codable conformance to NSManagedObject: https://gist.github.com/Akhu/5ea1ecbd652fb269f7c4e7db27bc79cc
//

import Foundation
import CoreData
import OSLog

import Darwin
import ApplicationServices


typealias rpidFunc = @convention(c) (CInt) -> CInt
let MaxPathLen = Int(4 * MAXPATHLEN)
let InfoSize = Int32(MemoryLayout<proc_bsdinfo>.stride)

@objc(ESMessage)
public class ESMessage: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        
        /// Version and sequence
        case version
        case schema_version
        case seq_num
        case global_seq_num
        
        /// Time
        case time
        case mach_time
        case message_darwin_time
        
        /// Platform -- Mac Monitor enrichment
        case macOS
        case sensor_id
        
        /// Initiating Process
        case process
        
        /// Thread
        case thread
        
        /// Event
        /// A process execution event. Corresponds to `ES_EVENT_TYPE_NOTIFY_EXEC`
        case event
        case event_type
        /// @note Mac Monitor enrichment
        case es_event_type
        
        /// Action
        case action_type
        case action
        /// `ES_ACTION_TYPE_AUTH` vs. `ES_ACTION_TYPE_NOTIFY`
        case action_type_string
        
        /// "context" will be a context item independent of `target_path`
        /// /// @note Mac Monitor enrichment
        case context
        
        /// `target_path` represents a path "targeted" by some ES event. For example,
        /// * ``MMapEvent`` events will have the `target_path` field set for their `path`
        /// * ``ProcessExecEvent`` events will have the `target_path` field set for their `process_path`
        /// * Similarly, for events like ``FileWriteEvent`` the `target_path` will be set for the file's destination path.
        /// > Not all events will have this populated. For example, it doesn't make sense for ``IOKitOpenEvent`` events to have a target path.
        /// /// @note Mac Monitor enrichment
        case target_path
    }
    
    public var action: ActionResultWrapper? {
        get {
            guard let data = actionResultData else { return nil }
            return try? JSONDecoder().decode(ActionResultWrapper.self, from: data)
        }
        set {
            guard let newValue = newValue else {
                actionResultData = nil
                return
            }
            actionResultData = try? JSONEncoder().encode(newValue)
        }
    }

    
    // MARK: - Custom Core Data entity creation from ESMessage type
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let description: NSEntityDescription = NSEntityDescription.entity(forEntityName: "ESMessage", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = message.id
        
        /// Version and sequence
        self.version = Int32(message.version)
        self.schema_version = Int32(message.schema_version)
        if let seq_num = message.seq_num {
            self.seq_num = Int64(seq_num)
        }
        if let global_seq_num = message.global_seq_num {
            self.global_seq_num = Int64(global_seq_num)
        }
        
        
        /// Time
        self.time = message.time
        self.mach_time = Int64(message.mach_time)
        self.message_darwin_time = message.message_darwin_time
        
        /// Platform -- Mac Monitor enrichment
        self.macOS = message.macOS
        self.sensor_id = message.sensor_id
        
        /// Initiating Process
        self.process = ESProcess(
            from: message.process,
            version: message.version,
            insertIntoManagedObjectContext: context
        )
        
        /// Thread
        self.thread = ESThread(
            from: message.thread,
            insertIntoManagedObjectContext: context
        )
        
        /// Event
        /// A process execution event. Corresponds to `ES_EVENT_TYPE_NOTIFY_EXEC`
        self.event = ESEventType(
            from: message,
            insertIntoManagedObjectContext: context
        )
        self.event_type = Int32(message.event_type)
        /// @note Mac Monitor enrichment
        self.es_event_type = message.es_event_type
        
        /// Action
        self.action_type = Int32(message.action_type)
        /// `ES_ACTION_TYPE_AUTH` vs. `ES_ACTION_TYPE_NOTIFY`
        self.action_type_string = message.action_type_string
        self.action = message.action
        
        /// "context" will be a context item independent of `target_path`
        /// /// @note Mac Monitor enrichment
        self.context = message.context ?? "Not supported"
        
        /// `target_path` represents a path "targeted" by some ES event. For example,
        /// * ``MMapEvent`` events will have the `target_path` field set for their `path`
        /// * ``ProcessExecEvent`` events will have the `target_path` field set for their `process_path`
        /// * Similarly, for events like ``FileWriteEvent`` the `target_path` will be set for the file's destination path.
        /// > Not all events will have this populated. For example, it doesn't make sense for ``IOKitOpenEvent`` events to have a target path.
        /// /// @note Mac Monitor enrichment
        self.target_path = message.target_path ?? "Not supported"
    }
    
    // MARK: - Custom Core Data entity creation from ESMessage type
    convenience init(from message: Message) {
        self.init()
        self.id = message.id
        
        /// Version and sequence
        self.version = Int32(message.version)
        self.schema_version = Int32(message.schema_version)
        if let seq_num = message.seq_num {
            self.seq_num = Int64(seq_num)
        }
        if let global_seq_num = message.global_seq_num {
            self.global_seq_num = Int64(global_seq_num)
        }
        
        /// Time
        self.time = message.time
        self.mach_time = Int64(message.mach_time)
        self.message_darwin_time = message.message_darwin_time
        
        /// Platform -- Mac Monitor enrichment
        self.macOS = message.macOS
        self.sensor_id = message.sensor_id
        
        /// Initiating Process
        self.process = ESProcess(from: message.process, version: message.version)
        
        /// Thread
        self.thread = ESThread(from: message.thread)
        
        /// Event
        /// A process execution event. Corresponds to `ES_EVENT_TYPE_NOTIFY_EXEC`
        self.event = ESEventType(from: message)
        self.event_type = Int32(message.event_type)
        /// @note Mac Monitor enrichment
        self.es_event_type = message.es_event_type
        
        /// Action
        self.action = message.action
        self.action_type = Int32(message.action_type)
        self.action_type_string = message.action_type_string
        
        /// "context" will be a context item independent of `target_path`
        /// /// @note Mac Monitor enrichment
        self.context = message.context ?? "Not supported"
        
        /// `target_path` represents a path "targeted" by some ES event. For example,
        /// * ``MMapEvent`` events will have the `target_path` field set for their `path`
        /// * ``ProcessExecEvent`` events will have the `target_path` field set for their `process_path`
        /// * Similarly, for events like ``FileWriteEvent`` the `target_path` will be set for the file's destination path.
        /// > Not all events will have this populated. For example, it doesn't make sense for ``IOKitOpenEvent`` events to have a target path.
        /// /// @note Mac Monitor enrichment
        self.target_path = message.target_path ?? "Not supported"
    }
    
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        self.init()
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            try id = container.decode(UUID.self, forKey: .id)
            
            /// Version and sequence
            try self.version = container.decode(Int32.self, forKey: .version)
            try self.schema_version = container.decode(Int32.self, forKey: .schema_version)
            if version >= 2 {
                try self.seq_num = container.decode(Int64.self, forKey: .seq_num)
            }
            if version >= 4 {
                try self.global_seq_num = container.decode(Int64.self, forKey: .global_seq_num)
            }
            
            /// Time
            try time = container.decode(String.self, forKey: .time)
            try mach_time = container.decode(Int64.self, forKey: .mach_time)
            try message_darwin_time = container.decode(Date.self, forKey: .message_darwin_time)
            
            /// Platform -- Mac Monitor enrichment
            try macOS = container.decode(String.self, forKey: .macOS)
            try sensor_id = container.decode(String.self, forKey: .sensor_id)
            
            /// Initiating Process
            try process = container.decode(ESProcess.self, forKey: .process)
            
            /// Thread
            try thread = container.decode(ESThread.self, forKey: .thread)
            
            /// Event
            /// A process execution event. Corresponds to `ES_EVENT_TYPE_NOTIFY_EXEC`
            try event = container.decode(ESEventType.self, forKey: .event)
            try event_type = container.decode(Int32.self, forKey: .event_type)
            /// @note Mac Monitor enrichment
            try es_event_type = container.decode(String.self, forKey: .es_event_type)
            
            /// Action
            try action = container.decode(ActionResultWrapper.self, forKey: .action)
            try action_type = container.decode(Int32.self, forKey: .action_type)
            try action_type_string = container
                .decode(String.self, forKey: .action_type_string)
            
            /// "context" will be a context item independent of `target_path`
            /// /// @note Mac Monitor enrichment
            try context = container.decode(String.self, forKey: .context)
            
            /// `target_path` represents a path "targeted" by some ES event. For example,
            /// * ``MMapEvent`` events will have the `target_path` field set for their `path`
            /// * ``ProcessExecEvent`` events will have the `target_path` field set for their `process_path`
            /// * Similarly, for events like ``FileWriteEvent`` the `target_path` will be set for the file's destination path.
            /// > Not all events will have this populated. For example, it doesn't make sense for ``IOKitOpenEvent`` events to have a target path.
            /// /// @note Mac Monitor enrichment
            try target_path = container.decode(String.self, forKey: .target_path)
        } catch {
            os_log("Error decoding ESEvent")
        }
    }
}

// MARK: - Encodable conformance
extension ESMessage: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        /// Version and sequence
        try container.encode(version, forKey: .version)
        try container.encode(schema_version, forKey: .schema_version)
        if version >= 2 {
            try container.encode(seq_num, forKey: .seq_num)
        }
        if version >= 4 {
            try container.encode(global_seq_num, forKey: .global_seq_num)
        }
        
        /// Time
        try container.encode(time, forKey: .time)
        try container.encode(mach_time, forKey: .mach_time)
        
        /// Platform -- Mac Monitor enrichment
        try container.encode(macOS, forKey: .macOS)
        try container.encode(sensor_id, forKey: .sensor_id)
        
        /// Initiating Process
        try container.encode(process, forKey: .process)
        
        /// Thread
        try container.encode(thread, forKey: .thread)
        
        /// Event
        /// A process execution event. Corresponds to `ES_EVENT_TYPE_NOTIFY_EXEC`
        try container.encodeIfPresent(event, forKey: .event)
        /// @note Mac Monitor enrichment
        try container.encode(event_type, forKey: .event_type)
        try container.encode(es_event_type, forKey: .es_event_type)
        
        /// Action
        try container.encode(action, forKey: .action)
        try container.encode(action_type, forKey: .action_type)
        try container.encode(action_type_string, forKey: .action_type_string)
        
        /// "context" will be a context item independent of `target_path`
        /// /// @note Mac Monitor enrichment
        try container.encode(context, forKey: .context)
        
        /// `target_path` represents a path "targeted" by some ES event. For example,
        /// * ``MMapEvent`` events will have the `target_path` field set for their `path`
        /// * ``ProcessExecEvent`` events will have the `target_path` field set for their `process_path`
        /// * Similarly, for events like ``FileWriteEvent`` the `target_path` will be set for the file's destination path.
        /// > Not all events will have this populated. For example, it doesn't make sense for ``IOKitOpenEvent`` events to have a target path.
        /// /// @note Mac Monitor enrichment
        try container.encode(target_path, forKey: .target_path)
    }
}
