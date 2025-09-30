//
//  EnrichedEventView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 10/17/22.
//

import SwiftUI
import SystemExtensions
import SutroESFramework
import OSLog
import Charts


//struct EnrichedTableView: View {
//    @Environment(\.openWindow) private var openEventJSON
//
//    var eventsInScope: [RCEvent]
//    @State private var unifiedEventSelection = Set<RCEvent.ID>()
//
//    var body: some View {
//        Table(selection: $unifiedEventSelection) {
//            TableColumn("Event type") { event in
//                EventTypeLabel(event: event)
//            }.width(min: 150, ideal: 200, max: 300)
//            TableColumn("Initiating process name") { event in
//                Text(event.initiating_process_name!)
//            }.width(min: 80, ideal: 100, max: 200)
//            TableColumn("Initiating pid") { event in
//                Text(String(event.initiating_pid!))
//            }.width(min: 20, ideal: 30, max: 50)
//            TableColumn("Initiating process path") { event in
//                let path = event.initiating_process_path!
//                Text("`\(path)`")
//            }.width(min: 50, ideal: 200, max: 500)
//            TableColumn("Initiating process signing ID") { event in
//                Text(event.initiating_process_signing_id!)
//            }.width(min: 80, ideal: 100, max: 200)
//        } rows: {
//            ForEach(eventsInScope) { event in
//                TableRow(event).contextMenu {
//                    Button(action: {
//                        openEventJSON(value: event.id)
//                    }) { Text("View event JSON") }
//                }
//              }
//        }
//    }
//}


struct RCCorrelatedEventsView: View {
    var correlatedEvents: [RCEvent]
    @State private var eventSelection = Set<RCEvent.ID>()
    
    private var forkEvents: [RCEvent] { correlatedEvents.filter { $0.fork_event != nil } }
    private var fileEvents: [RCEvent] { correlatedEvents.filter({ $0.file_event != nil }) }
    private var memoryEvents: [RCEvent] { correlatedEvents.filter { $0.mmap_event != nil } }
    private var fileMetadataEvents: [RCEvent] { correlatedEvents.filter({ $0.delete_xattr_event != nil }) }
    private var launchItemEvents: [RCEvent] { correlatedEvents.filter { $0.btm_launch_item_add_event != nil } }
    
    var body: some View {
        // Child processes (NOTIFY_FORK)
        if forkEvents.count > 0 {
            Divider()
            Section("**Child processes (\(forkEvents.count))**") {
                ProcessForkTableView(forkEvents: forkEvents, eventSelection: $eventSelection).textSelection(.enabled)
            }
        }
        
        // File modifications (NOTIFY_CREATE)
        if fileEvents.count > 0 {
            Divider()
            Section("**File modifications (\(fileEvents.count))**"){
                FileTableView(fileEvents: fileEvents, eventSelection: $eventSelection).textSelection(.enabled)
            }
        }
        
        // File modifications (NOTIFY_MMAP)
        if memoryEvents.count > 0 {
            Divider()
            Section("**Memory mappings (\(memoryEvents.count))**") {
                MemoryMapTableView(mmapEvents: memoryEvents, eventSelection: $eventSelection).textSelection(.enabled)
            }
        }
        
        // xattr events (NOTIFY_DELETE_XATTR, etc.)
        if fileMetadataEvents.count > 0 {
            Divider()
            Section("**File metadata (\(fileMetadataEvents.count))**") {
                FileMetadataGroupTableViews(eventsInScope: correlatedEvents, eventSelection: $eventSelection).textSelection(.enabled)
            }
        }
        
        // Service Management Framework background items (ES_EVENT_TYPE_NOTIFY_BTM_LAUNCH_ITEM_ADD)
        if launchItemEvents.count > 0 {
            Divider()
            Section("**Background Items (\(launchItemEvents.count))**") {
                LaunchItemTableView(launchItemEvents: launchItemEvents, eventSelection: $eventSelection)
            }
        }
    }
}


//struct EnrichedEventView: View {
//    var correlatedEvents: [RCEvent: [RCEvent]]
//    var selectedRCEvent: RCEvent
//    
//    var body: some View {
//        Form {
//            VStack(alignment: .leading) {
//                HStack {
//                    EventTypeLabel(event: selectedRCEvent)
//                    Spacer()
//                    Text("`\(selectedRCEvent.initiating_process_path!)`").help("Initiating process path")
//                }
//                
//                Divider()
//                
//                Section("**Unified correlated ES events (\(correlatedEvents[selectedRCEvent]!.count))**") {
//                    EnrichedTableView(eventsInScope: correlatedEvents[selectedRCEvent]!)
//                }
//                
//                RCCorrelatedEventsView(correlatedEvents: correlatedEvents[selectedRCEvent]!)
//            }.padding([.top, .leading, .trailing])
//        }
//        
//    }
//}
