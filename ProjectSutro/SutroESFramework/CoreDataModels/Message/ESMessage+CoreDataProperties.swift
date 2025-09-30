//
//  ESEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 11/15/22.
//
//

import Foundation
import CoreData

extension ESMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESMessage> {
        return NSFetchRequest<ESMessage>(entityName: "ESMessage")
    }
    
    @NSManaged public var id: UUID
    
    /// Version and sequence
    @NSManaged public var version, schema_version: Int32
    @NSManaged public var seq_num, global_seq_num: Int64
    
    /// Time
    @NSManaged public var time: String?
    @NSManaged public var mach_time: Int64
    @NSManaged public var message_darwin_time: Date?
    
    /// Platform -- Mac Monitor enrichment
    @NSManaged public var macOS: String?
    @NSManaged public var sensor_id: String?
    
    /// Initiating process
    @NSManaged public var process: ESProcess
    
    /// Thread
    @NSManaged public var thread: ESThread
    
    /// Event
    /// A process execution event. Corresponds to `ES_EVENT_TYPE_NOTIFY_EXEC`
    @NSManaged public var event: ESEventType
    @NSManaged public var event_type: Int32
    /// @note Mac Monitor enrichment
    @NSManaged public var es_event_type: String?
    
    /// Action
    @NSManaged public var action_type: Int32
    @NSManaged public var action_type_string: String
    @NSManaged public var actionResultData: Data?
    
    /// "context" will be a context item independent of `target_path`
    /// /// @note Mac Monitor enrichment
    @NSManaged public var context: String?
    
    
    /// `target_path` represents a path "targeted" by some ES event. For example,
    /// * ``MMapEvent`` events will have the `target_path` field set for their `path`
    /// * ``ProcessExecEvent`` events will have the `target_path` field set for their `process_path`
    /// * Similarly, for events like ``FileWriteEvent`` the `target_path` will be set for the file's destination path.
    /// > Not all events will have this populated. For example, it doesn't make sense for ``IOKitOpenEvent`` events to have a target path.
    /// /// @note Mac Monitor enrichment
    @NSManaged public var target_path: String?
    
    
    // MARK: - Correlations
    @NSManaged public var correlated_events: NSSet?
    @NSManaged public var correlated_gid_events: NSSet?
    
    
    public var correlated_array: [ESMessage] {
        let set = correlated_events as? Set<ESMessage> ?? []
        
        return set.sorted {
            $0.mach_time > $1.mach_time
        }
    }
    
    public var correlated_gid_array: [ESMessage] {
        let set = correlated_gid_events as? Set<ESMessage> ?? []
        
        return set.sorted {
            $0.mach_time > $1.mach_time
        }
    }
}

// MARK: Generated accessors for correlated_events
extension ESMessage {
    @objc(addCorrelated_eventsObject:)
    @NSManaged public func addToCorrelated_events(_ value: ESMessage)

    @objc(removeCorrelated_eventsObject:)
    @NSManaged public func removeFromCorrelated_events(_ value: ESMessage)

    @objc(addCorrelated_events:)
    @NSManaged public func addToCorrelated_events(_ values: NSSet)

    @objc(removeCorrelated_events:)
    @NSManaged public func removeFromCorrelated_events(_ values: NSSet)
    
    @objc(removeCorrelatedGroupID_eventsObject:)
    @NSManaged public func removeFromCorrelatedGroupID_events(_ value: ESMessage)
    
    @objc(addCorrelatedGroupID_eventsObject:)
    @NSManaged public func addToCorrelatedGroupID_events(_ value: ESMessage)

    @objc(addCorrelatedGroupID_events:)
    @NSManaged public func addToCorrelatedGroupID_events(_ values: NSSet)

}

extension ESMessage : Identifiable {

}
