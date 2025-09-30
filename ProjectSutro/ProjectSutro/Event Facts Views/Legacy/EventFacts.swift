//
//  EventFacts.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 10/28/22.
//

import SwiftUI
import SutroESFramework
import OSLog


struct EventJSONView: View {
    var selectedRCEvent: RCEvent
    
    var body: some View {
        Section("**Event JSON**") {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("```\(RCProcessHelpers.eventToPrettyJSON(value: selectedRCEvent))```").foregroundColor(.white).background(Rectangle().fill(Color.black)).textSelection(.enabled)
                }
            }.frame(maxWidth: .infinity)
        }
    }
}


struct ProcessEntitlementsView: View {
    var selectedRCEvent: RCEvent
    
    var body: some View {
        let execEvent: RCProcessExecEvent = selectedRCEvent.exec_event!
        Divider()
        Section("**Process entitlements**") {
            // If exec or mmap event let's enrich
            HStack {
                if execEvent.skip_lv {
                    Text(" `com.apple.security.cs.disable-library-validation` ").background(Capsule().fill(.red).opacity(0.3))
                }
                
                if execEvent.get_task_allow {
                    Text(" `com.apple.security.get-task-allow` ").background(Capsule().fill(.red).opacity(0.3))
                }
                
                if execEvent.rootless {
                    Text(" `com.apple.rootless.*` ").background(Capsule().fill(.red).opacity(0.3))
                }
                
                if execEvent.allow_jit {
                    Text(" `com.apple.security.cs.allow-jit` ").background(Capsule().fill(.red).opacity(0.3))
                }
                
            }.textSelection(.enabled).padding(1)
        }
    }
}

struct initiatingProcessDisclosureGroupView: View {
    var selectedRCEvent: RCEvent
    @State private var initiatingMetadataExpanded: Bool = false
    
    var body: some View {
        DisclosureGroup("**Initiating process:** `\(selectedRCEvent.initiating_process_name!)`", isExpanded: $initiatingMetadataExpanded) {
            Text("\u{2022} **initiating process name:** `\(selectedRCEvent.initiating_process_name!)`")
            Text("\u{2022} **initiating process path:** `\(selectedRCEvent.initiating_process_path!)`")
            Text("\u{2022} **initiating process signing ID:** `\(selectedRCEvent.initiating_process_signing_id!)`")
            Text("\u{2022} **initiating PID:** `\(String(selectedRCEvent.initiating_pid!))`")
            DisclosureGroup("**Audit tokens**") {
                Text("\u{2022} **Initiating process audit token:** `\(selectedRCEvent.audit_token!)`")
                Text("\u{2022} **Responsible audit token:** `\(selectedRCEvent.responsible_audit_token!)`")
                Text("\u{2022} **Parent audit token:** `\(selectedRCEvent.parent_audit_token!)`")
            }
        }
    }
}

struct TargetExecProcMetadataView: View {
    var execEvent: RCProcessExecEvent
    
    var body: some View {
        Text("\u{2022} **Process name:** `\(execEvent.process_name!)`")
        Text("\u{2022} **Process path:** `\(execEvent.process_path!)`")
//                Text("\u{2022} **Process signing ID:** `\(execEvent.signing_id!)`    \u{2022} **Team ID:** `\(execEvent.team_id != nil ? execEvent.team_id! : "Unknown")`")
        Text("\u{2022} **Process signing ID:** `\(execEvent.signing_id != nil ? execEvent.signing_id! : "Unknown")`")
        Text("\u{2022} **Is platform binary?** `\(execEvent.is_platform_binary ? "Yes" : "No")`")
        Text("\u{2022} **Command line** `\(execEvent.command_line!)`").lineLimit(4)
        DisclosureGroup("**Audit tokens**") {
            Text("\u{2022} **Process audit token:** `\(execEvent.audit_token!)`")
            Text("\u{2022} **Responsible audit token:** `\(execEvent.responsible_audit_token!)`")
            Text("\u{2022} **Parent audit token:** `\(execEvent.parent_audit_token!)`")
        }
    }
}

struct TargetProcessDisclosureGroupView: View {
    var selectedRCEvent: RCEvent
    @State private var targetMetadataExpanded: Bool = true
    
    var body: some View {
        DisclosureGroup("**Target event metadata**", isExpanded: $targetMetadataExpanded) {
//            Text("\u{2022} **PID:** `\(String(selectedRCEvent.init!))`")
            // Insert event specific metadata
            if selectedRCEvent.exec_event != nil {
                let execEvent: RCProcessExecEvent = selectedRCEvent.exec_event!
                TargetExecProcMetadataView(execEvent: execEvent)
            } else if selectedRCEvent.fork_event != nil {
                let forkEvent: RCProcessForkEvent = selectedRCEvent.fork_event!
                Text("\u{2022} **Process name:** `\(forkEvent.process_name!)`")
                Text("\u{2022} **Process path:** `\(forkEvent.process_path!)`")
                Text("\u{2022} **Process signing ID:** `\(forkEvent.signing_id!)`")
                Text("\u{2022} **PID** `\(String(forkEvent.pid))`")
                DisclosureGroup("**Audit tokens**") {
                    Text("\u{2022} **Process audit token:** `\(forkEvent.audit_token!)`")
                    Text("\u{2022} **Responsible audit token:** `\(forkEvent.responsible_audit_token!)`")
                    Text("\u{2022} **Parent audit token:** `\(forkEvent.parent_audit_token!)`")
                }
            } else if selectedRCEvent.file_event != nil {
                let fileEvent: RCFileEvent = selectedRCEvent.file_event!
                Text("\u{2022} **File destination path:** `\(fileEvent.destination_path!)`")
                Text("\u{2022} **File name:** `\(fileEvent.file_name!)`")
            } else if selectedRCEvent.exit_event != nil {
                let exitEvent: RCProcessExitEvent = selectedRCEvent.exit_event!
            } else if selectedRCEvent.mmap_event != nil {
                let mmapEvent: RCMMapEvent = selectedRCEvent.mmap_event!
                Text("\u{2022} **Mapped path:** `\(mmapEvent.path)`")
            } else if selectedRCEvent.btm_launch_item_add_event != nil {
                let addLaunchItemEvent: RCLaunchItemAddEvent = selectedRCEvent.btm_launch_item_add_event!
                Text("\u{2022} **Persistence Type:** `\(addLaunchItemEvent.type)`")
                Text("\u{2022} **File name:** `\(addLaunchItemEvent.file_name)`")
                Text("\u{2022} **File path:** `\(addLaunchItemEvent.file_path)`")
            } else if selectedRCEvent.delete_xattr_event != nil {
                let deleteXattrEvent: RCXattrDeleteEvent = selectedRCEvent.delete_xattr_event!
                HStack {
                    Text("\u{2022} **Extended attribute:** `\(deleteXattrEvent.xattr!)`")
                }
                
                Text("\u{2022} **File name:** `\(deleteXattrEvent.file_name!)`")
                Text("\u{2022} **File path:** `\(deleteXattrEvent.file_path!)`")
            }
        }
    }
}

//struct TargetProcessSimpleView: View {
//    var body: some View {
//        
//    }
//}


struct EventDetailsView: View {
    @EnvironmentObject var systemExtensionManager: EndpointSecurityManager
    @Environment(\.openWindow) private var openEventJSON
    
    var selectedRCEvent: RCEvent
    var correlatedEvents: [RCEvent: [RCEvent]]
    @State private var targetMetadataExpanded: Bool = true
    
    var potentialParent: RCEvent? { systemExtensionManager.getResponsibleParentExecEvent(rcEvent: selectedRCEvent) }
    
    var body: some View {
        Section("**Event Details**") {
            if selectedRCEvent.exec_event != nil && selectedRCEvent.initiating_pid == 1 {
                HStack {
                    EventTypeLabel(event: selectedRCEvent).padding(1)
                    if potentialParent != nil {
                        if potentialParent!.exec_event != nil {
                            if correlatedEvents[potentialParent!] != nil && correlatedEvents[potentialParent!]!.count > 0 {
                                Button("Parent: `\(potentialParent!.exec_event!.process_name!)` **w/\(correlatedEvents[potentialParent!]!.count)**") {
                                    openEventJSON(value: potentialParent!.id)
                                }
                            } else {
                                Button("Parent: `\(potentialParent!.exec_event!.process_name!)`") {
                                    openEventJSON(value: potentialParent!.id)
                                }
                            }
                        } else if potentialParent!.fork_event != nil {
                            Button("Parent: `\(potentialParent!.fork_event!.process_name!)`") {
                                openEventJSON(value: potentialParent!.id)
                            }
                        }
                    }
                }
                Text("  via Launch Services (likely interactive)  ").background(Capsule().fill(.green).opacity(0.3)).padding(1)
            } else {
                HStack {
                    EventTypeLabel(event: selectedRCEvent).padding(1)
                    if potentialParent != nil {
                        if potentialParent!.exec_event != nil {
                            if correlatedEvents[potentialParent!] != nil && correlatedEvents[potentialParent!]!.count > 0 {
                                Button("Parent: `\(potentialParent!.exec_event!.process_name!)` **w/\(correlatedEvents[potentialParent!]!.count)**") {
                                    openEventJSON(value: potentialParent!.id)
                                }
                            } else {
                                Button("Parent: `\(potentialParent!.exec_event!.process_name!)`") {
                                    openEventJSON(value: potentialParent!.id)
                                }
                            }
                        } else if potentialParent!.fork_event != nil {
                            Button("Parent: `\(potentialParent!.fork_event!.process_name!)`") {
                                openEventJSON(value: potentialParent!.id)
                            }
                        }
                        
                    }
                }
            }
            
            List {
                Section {
                    initiatingProcessDisclosureGroupView(selectedRCEvent: selectedRCEvent)
                    Divider()
                    Section {
                        TargetProcessDisclosureGroupView(selectedRCEvent: selectedRCEvent)
                    }
                }
            }
            
        }.textSelection(.enabled)
        
        // Exec event code signing information
        if selectedRCEvent.exec_event != nil {
            Divider()
            Section("**Target process code signing status**") {
                let execEvent: RCProcessExecEvent = selectedRCEvent.exec_event!
                if execEvent.is_adhoc_signed {
                    Text("  Adhoc Signed  ").background(Capsule().fill(.red).opacity(0.3)).padding(1)
                } else if execEvent.signing_id != nil {
                    Text("  \(execEvent.signing_id!)  ").background(Capsule().fill(.blue).opacity(0.3)).padding(1)
                } else {
                    Text("  Validly signed  ").background(Capsule().fill(.blue).opacity(0.3)).padding(1)
                }
            }.textSelection(.enabled)
        }
    }
}

struct EventFactsSplitView: View {
    @State private var viewEnriched: Bool = false
    var selectedRCEvent: RCEvent
    var correlatedEvents: [RCEvent: [RCEvent]]
    
    var body: some View {
        NavigationSplitView {
            // Insert proc lineage List
        } detail: {
            
        }
    }
}

//struct EventFactsView : View {
//    @State private var viewEnriched: Bool = false
//    var selectedRCEvent: RCEvent
//    var correlatedEvents: [RCEvent: [RCEvent]]
//
//    var body: some View {
////        NavigationStack {
////            NavigationLink(value: selectedRCEvent) {
////                Label("", image: <#T##String#>)
////            }
////        }.navigationTitle("Event Facts")
//
//        if !viewEnriched {
//            VStack(alignment: .leading) {
//                Form {
//                    VStack(alignment: .leading) {
//                        EventDetailsView(selectedRCEvent: selectedRCEvent, correlatedEvents: correlatedEvents)
//
//                        // Process entitlements (if this is an exec event)
//                        if selectedRCEvent.exec_event != nil {
//                            // If there are any entitlements show them
//                            let execEvent = selectedRCEvent.exec_event!
//                            if execEvent.skip_lv || execEvent.allow_jit || execEvent.get_task_allow || execEvent.rootless {
//                                ProcessEntitlementsView(selectedRCEvent: selectedRCEvent)
//                            }
//                        }
//                    }
//                    Divider()
//                    EventJSONView(selectedRCEvent: selectedRCEvent).frame(maxWidth: .infinity, alignment: .bottomLeading)
//                }
//            }.padding(.all)
//        } else {
//            // Load up the correlated event view!
//            if correlatedEvents[selectedRCEvent] != nil {
//                EnrichedEventView(correlatedEvents: correlatedEvents, selectedRCEvent: selectedRCEvent)
//            }
//        }
//
//        // Fact view switcher: Metadata and correlated events
//        HStack {
//            if !viewEnriched {
//                if correlatedEvents[selectedRCEvent] != nil && correlatedEvents[selectedRCEvent]!.count > 0 {
//                    Button("View \(correlatedEvents[selectedRCEvent]!.count) correlated events") {
//                        viewEnriched = true
//                    }
//                } else {
//                    Text("No correlated events found.").padding(.bottom)
//                }
//
//            } else {
//                Button("View metadata") {
//                    viewEnriched = false
//                }
//            }
//        }.padding(.bottom)
//
//    }
//}
