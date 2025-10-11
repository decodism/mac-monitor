//
//  CoreDataController.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/7/23.
//

import Foundation
import CoreData
import OSLog
import AppKit
import UniformTypeIdentifiers

/// Exposes functions and helpers to manage system event entities stored in Core Data
///
/// Reference: [Setting up a Core Data Stack](https://developer.apple.com/documentation/coredata/setting_up_a_core_data_stack)
///
public class CoreDataController {
    public static let shared = CoreDataController()
    private static let logger = Logger(subsystem: "com.swiftlydetecting.agent", category: "CoreDataController")
    
    /// Main context
    ///
    /// On the main thread: `container.viewContext`. This main context is designed to be used
    /// to update the UI.
    public var container: NSPersistentContainer
    
    /// Background context
    ///
    /// Designed for asyncronous operations like batch inserting.
    private let privateMOC: NSManagedObjectContext
    


    /// Set up the in-memory Core Data PSC named: `SystemEvents`
    init() {
        container = NSPersistentContainer(name: "SystemEvents")
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                CoreDataController.logger.error("Unable to create the Core Data PSC \(error)!")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // New background context to handle off-main thread tasks
        privateMOC = container.newBackgroundContext()
        privateMOC.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        privateMOC.retainsRegisteredObjects = true
        
    }
    
    // MARK: - Mutators
    
    /// Inserts a batch of system events into the private context efficiently with optimized, two-pass correlation.
    ///
    /// 1.  **Pre-fetch & First Pass (Create):** It collects all parent audit tokens from the incoming batch and
    ///     performs a single fetch to get known parent processes (`EXEC` or `FORK` events) from the database.
    ///     It then creates all `ESMessage` objects for the current batch, adding new parent-candidate events
    ///     to a temporary lookup dictionary. This handles cases where a parent and child are in the same batch.
    /// 2.  **Second Pass (Correlate):** It iterates through the newly created events and finds the parent for each
    ///     by checking the temporary dictionary first, then the pre-fetched dictionary. This establishes the relationship.
    ///
    /// The entire operation, including one final save, is performed in a single background transaction.
    ///
    ///  - Parameters:
    ///    - messages: An array of system events (`Message`) to insert.
    ///
    public func insertSystemEvents(messages: [Message]) {
        guard !messages.isEmpty else { return }
        
        privateMOC.perform {
            let context = self.privateMOC
            
            // 1. Collect all parent audit tokens from the incoming batch.
            // The parent of an event is the process that instigated it.
            let parentAuditTokens = Set(messages.map { $0.process.audit_token_string })
            
            // 2. Pre-fetch all potential parents (EXEC and FORK events) from the persistent store.
            let request = NSFetchRequest<ESMessage>(entityName: "ESMessage")
            request.predicate = NSPredicate(
                format: "(event.exec != NULL AND event.exec.target.audit_token_string IN %@) OR (event.fork != NULL AND event.fork.child.audit_token_string IN %@)",
                parentAuditTokens, parentAuditTokens
            )
            request.returnsObjectsAsFaults = false
            
            var persistentParentLookup: [String: ESMessage] = [:]
            do {
                let potentialParents = try context.fetch(request)
                for parent in potentialParents {
                    if let token = parent.event.exec?.target.audit_token_string {
                        persistentParentLookup[token] = parent
                    } else if let token = parent.event.fork?.child.audit_token_string {
                        persistentParentLookup[token] = parent
                    }
                }
            } catch {
                CoreDataController.logger.error("Failed to pre-fetch parent processes for correlation: \(error)")
            }
            
            // 3. First Pass: Create all new objects and populate a temporary lookup for intra-batch correlation.
            var newMessages: [ESMessage] = []
            var newParentLookup: [String: ESMessage] = [:]
            
            for message in messages {
                let systemESMessage = ESMessage(from: message, insertIntoManagedObjectContext: context)
                newMessages.append(systemESMessage)
                
                // If the new event is itself a process-creating event, add it to our temporary lookup.
                if let token = systemESMessage.event.exec?.target.audit_token_string {
                    newParentLookup[token] = systemESMessage
                } else if let token = systemESMessage.event.fork?.child.audit_token_string {
                    newParentLookup[token] = systemESMessage
                }
            }
            
            // 4. Second Pass: Correlate using the combined lookups.
            for esMessage in newMessages {
                let parentToken = esMessage.process.audit_token_string
                
                // Find parent in the current batch first, then fall back to the persistent store.
                if let parent = newParentLookup[parentToken] ?? persistentParentLookup[parentToken] {
                    // Avoid self-correlation
                    if parent.objectID != esMessage.objectID {
                        parent.addToCorrelated_events(esMessage)
                    }
                }
            }
            
            // 5. Save the context once after all modifications are complete.
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    CoreDataController.logger.error("Error saving context after batch insert: \(error.localizedDescription)")
                }
            }
        }
    }
    
    ///  Remove all events from the in-memory store
    ///
    ///  Removes all `ESMessage` entities in the `SystemEvents` store. To do this we:
    ///  1) Create a batch delete request and execute
    ///  2) Asyncronously merge those chnages into the `container.viewContext` connected to the UI.
    ///
    public func clearSystemEvents() {
        privateMOC.performAndWait {
            do {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ESMessage")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
                deleteRequest.resultType = .resultTypeObjectIDs
                
                // Now we're safely on privateMOC's queue
                let result = try self.privateMOC.execute(deleteRequest)
                
                guard let deleteResult = result as? NSBatchDeleteResult,
                      let ids = deleteResult.result as? [NSManagedObjectID] else {
                    return
                }
                
                // The context is not aware of the changes yet, so we merge them.
                let changes = [NSDeletedObjectsKey: ids]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.container.viewContext, self.privateMOC])
                
            } catch {
                CoreDataController.logger.error("Error clearing system events: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Accessors
    
    ///  Given an entitiy `id` attempt to return its `ESMessage` representation from the store.
    ///
    ///
    ///  **Primary usecase:** Exporting telemetry.
    ///
    ///  - Parameters:
    ///     - id: The `UUID` of the entity to fetch from the in-memory Core Data store.
    /// - Returns: The object representation of the entity: `ESMessage?`
    ///
    public func getEntityByID(id: UUID) -> ESMessage? {
        let request = NSFetchRequest<ESMessage>(entityName: "ESMessage")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        do {
            // This fetch is for user-facing actions (like export), so fetching
            // from the viewContext is acceptable here. This must be called from the main thread.
            let result = try self.container.viewContext.fetch(request)
            return result.first
        } catch {
            CoreDataController.logger.error("Could not find the Core Data record by UUID of: \(id)")
        }
        
        return nil
    }
    
    /// Get all `EXEC` events in a given process group.
    ///
    /// - Parameters:
    ///   - targetEvent: Provide a system event and we'll extract the `group_id` field to find the others in the same process group.
    /// - Returns: `[ESMessage]` the list of `EXEC` events in the same process group.
    ///
    public func getProcGroup(message: ESMessage) -> [ESMessage] {
        let groupFetchRequest = NSFetchRequest<ESMessage>(entityName: "ESMessage")
        let event = message.event
        var gid: Int = Int(message.process.group_id)
        if let exec = event.exec {
            gid = Int(exec.target.group_id)
        }
        
        groupFetchRequest.predicate = NSPredicate(format: "event.exec != NULL AND event.exec.target.group_id == %d", gid)
        groupFetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try self.container.viewContext.fetch(groupFetchRequest)
            return result.sorted(by: {$0.mach_time > $1.mach_time})
        } catch {
            CoreDataController.logger
                .error(
                    "Error obtaining process group for \(message.process.executable?.name ?? "") ==> \(message.es_event_type!)"
                )
        }
        
        return []
    }
    
    /// Get all `EXEC` events in a given process session.
    ///
    /// - Parameters:
    ///   - targetEvent: Provide a system event and we'll extract the `session_id` field to find the others in the same session.
    /// - Returns: `[ESMessage]` the list of `EXEC` events in the same process session.
    ///
    public func getProcSessionGroup(message: ESMessage) -> [ESMessage] {
        let groupFetchRequest = NSFetchRequest<ESMessage>(entityName: "ESMessage")
        let event = message.event
        var session_id: Int = Int(message.process.session_id)
        if let exec = event.exec {
            session_id = Int(exec.target.group_id)
        }
        
        groupFetchRequest.predicate = NSPredicate(format: "event.exec != NULL AND event.exec.target.session_id == %d", session_id)
        groupFetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try self.container.viewContext.fetch(groupFetchRequest)
            return result.sorted(by: {$0.mach_time > $1.mach_time})
        } catch {
            CoreDataController.logger
                .error(
                    "Error obtaining session group for \(message.process.executable?.name ?? "") ==> \(message.es_event_type!)"
                )
        }
        
        return []
    }
    
    /// Construct a basic process tree given a target system event.
    ///
    /// We're calling `findParentProc`, appending the parent (if found) and then recursively calling ourselves: ``getProcTree(targetEvent:tree:)``
    ///
    ///  - Parameters:
    ///    - targetEvent: The event (`ESMessage`) to find the parent process for
    ///    - tree: The process tree generated recursively (`[ESMessage]`)
    ///  - Returns: A list of system events: `[ESMessage]` the flat representation of the process tree.
    ///
    public func getProcTree(targetEvent: ESMessage, tree: [ESMessage] = []) -> [ESMessage] {
        var procTree: [ESMessage] = tree
        
        let parent = findParentProc(message: targetEvent)
        if let parent = parent {
            procTree.append(parent)
            return getProcTree(targetEvent: parent, tree: procTree)
        } else {
            return procTree
        }
    }
    
    /// Find the parent process of a given system event
    ///
    /// Each `ESMessage` has an `initiating_process` we can attempt to find the corresponding `EXEC` and/or
    /// `FORK` event. What we're essentially doing here is looking for the matching exec event for the event's message's audit token
    /// ( the parent audit token).
    ///
    /// - Parameters:
    ///   - message: The system event to try and find the parent process for
    /// - Returns: `ESMessage?`: The system event, if we can find it
    ///
    public func findParentProc(message: ESMessage) -> ESMessage? {
        if message.process.audit_token == nil {
            return nil
        }
        
        // First try looking through the exec events
        let audit_token: String = message.process.audit_token_string
        let execFetchRequest = NSFetchRequest<ESMessage>(entityName: "ESMessage")
        execFetchRequest.predicate = NSPredicate(format: "event.exec != NULL AND event.exec.target.audit_token_string == %@", audit_token)
        execFetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try self.container.viewContext.fetch(execFetchRequest)
            if !results.isEmpty {
                return results.first
            }
        } catch {
            CoreDataController.logger
                .error(
                    "We could not find the parent proc for: \(message.process.executable?.name ?? "")"
                )
        }
        
        // Next try looking through the fork events
        // @note similar for fork events
        let forkFetchRequest = NSFetchRequest<ESMessage>(entityName: "ESMessage")
        forkFetchRequest.predicate = NSPredicate(format: "event.fork != NULL AND event.fork.child.audit_token_string == %@", audit_token)
        forkFetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try self.container.viewContext.fetch(forkFetchRequest)
            if !result.isEmpty {
                return result.first
            }
        } catch {
            CoreDataController.logger.error("We could not find the parent proc for: \(message.process.executable?.name ?? "")")
        }
        
        return nil
    }
    
    
    // MARK: - Telemetry export
    
    /// Export all system events to a file
    ///
    /// We can export all system events from the in-memory store to either JSON or JSONL format.
    /// This operation is performed safely on the background context.
    ///
    /// - Parameters:
    ///   - jsonl: Should we export the events line-by-line (one JSON object per line)?
    ///
    public func exportFullTrace(jsonl: Bool = false) {
        // UI work must be on the main thread.
        guard let telemetryFile = showSavePanel() else { return }
        
        privateMOC.perform {
            let request = NSFetchRequest<ESMessage>(entityName: "ESMessage")
            request.returnsObjectsAsFaults = false
            
            do {
                // 1. Fetch and process all data within the background context's queue.
                let messages = try self.privateMOC.fetch(request)
                let jsonLines = messages.map { message in
                    jsonl ? ProcessHelpers.eventToJSON(value: message) : ProcessHelpers.eventToPrettyJSON(value: message)
                }
                
                // 2. Pass the prepared data (not managed objects) to the main thread for file writing.
                DispatchQueue.main.async {
                    let finalJSON = jsonLines.joined(separator: "\n")
                    do {
                        try finalJSON.write(to: telemetryFile, atomically: true, encoding: .utf8)
                    } catch {
                        CoreDataController.logger.error("Failed to write exported trace to file: \(error)")
                    }
                }
            } catch {
                CoreDataController.logger.error("Failed to fetch events for export: \(error)")
            }
        }
    }
    
    /// Export specified system events to a file, sorted by `mach_time`.
    ///
    /// This operation is performed safely on the main thread, as it reads from the viewContext.
    ///
    /// - Parameters:
    ///   - eventIDs: A listing of the event `UUID`s we want to export.
    ///   - jsonl: Should we export the events line-by-line (one JSON object per line)?
    ///
    public func exportSelectedEvents(eventIDs: [UUID], jsonl: Bool = false) {
        // UI work must be on the main thread.
        guard let telemetryFile = showSavePanel(numberOfEvents: eventIDs.count) else { return }
        
        // All viewContext access and file writing will be on the main thread.
        DispatchQueue.main.async {
            var events: [ESMessage] = []
            events.reserveCapacity(eventIDs.count)
            
            for id in eventIDs {
                // self.getEntityByID safely uses the main `viewContext`
                if let event = self.getEntityByID(id: id) {
                    events.append(event)
                }
            }
            
            let sortedEvents = events.sorted { $0.mach_time < $1.mach_time }
            let jsonStrings = sortedEvents.map { event in
                jsonl ? ProcessHelpers.eventToJSON(value: event) : ProcessHelpers.eventToPrettyJSON(value: event)
            }
            let finalJSON = jsonStrings.joined(separator: "\n")
            
            guard !finalJSON.isEmpty else { return }
            do {
                try finalJSON.write(to: telemetryFile, atomically: true, encoding: .utf8)
            } catch {
                CoreDataController.logger.error("Failed to write selected events to file: \(error)")
            }
        }
    }
    
    /// AppKit UI to save system traces.
    ///
    /// Show the `NSSavePanel`
    ///
    /// - Parameters:
    ///   - numberOfEvents: The number of events to save (to be displayed in the UI)
    ///
    ///  - Returns: `URL?`:  The optional URL to save the telemetry to
    ///
    public func showSavePanel(numberOfEvents: Int = 0) -> URL? {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [UTType.json]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.allowsOtherFileTypes = false
        savePanel.title = numberOfEvents == 0 ? "Save full system trace" : "Save \(numberOfEvents) events"
        savePanel.message = "Choose a directory to export the trace to"
        savePanel.nameFieldLabel = "Telemetry file name:"
        let response = savePanel.runModal()
        return response == .OK ? savePanel.url : nil
    }
}

