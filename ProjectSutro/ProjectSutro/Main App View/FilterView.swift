//
//  FilterView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 12/16/22.
//

import SwiftUI
import SutroESFramework
import OSLog


public struct Filters {
    public var initiatingPaths: [String] = []
    public var targetPaths: [String] = []
    public var events: [String] = []
    public var userIDs: [String] = []
    
    public func totalFilters() -> Int {
        return initiatingPaths.count + targetPaths.count + events.count + userIDs.count
    }
}



public func isEventFiltered(event: ESMessage, filteringLongRunningProcs: Bool = false, filterText: String, allFilters: Filters, systemExtensionManager: EndpointSecurityManager) -> Bool {
    let shouldFilter: Bool = false
    
    // Filter by event time
    if filteringLongRunningProcs, let messageTime = event.message_darwin_time, messageTime.timeIntervalSince1970 < systemExtensionManager.clientConnectDT.timeIntervalSince1970 {
        return false
    }
    
    // By event type
    if allFilters.events.contains(event.es_event_type ?? "") {
        return false
    }
    
    // By effective user ID
    if allFilters.userIDs.contains(event.process.euid_human ?? "") {
        return false
    }
    
    // By initiating process path
    if allFilters.initiatingPaths
        .contains(event.process.executable?.path ?? "") {
        return false
    }
    
    if allFilters.targetPaths.contains(event.target_path ?? "") || !(allFilters.targetPaths.filter { (event.target_path ?? "").contains($0) }.isEmpty) {
        return false
    }
    
    // Filter text on target / "context"
    if !filterText.isEmpty, let target = event.context, !target.lowercased().contains(filterText) {
        return false
    }
    
    return !shouldFilter
}



struct FilterView: View {
    @EnvironmentObject var systemExtensionManager: EndpointSecurityManager
    
    @Binding var allFilters: Filters
    @Binding var filteredTelemetryShown: Bool
    @Binding var filterSelection: Set<String>
    @Binding var filteringLongRunningProcs: Bool
    @Binding var eventMaskEnabled: Bool
    @Binding var filterPlatform: Bool
    
    @State private var selectableEvents: [SelectableEvent] = getSupportedEventTypesSelectable()
    
    private var initiatingProcessPathFilters: [String] {
        allFilters.initiatingPaths
    }
    
    private var targetPathFilters: [String] {
        allFilters.targetPaths
    }
    
    private var eventFilters: Set<String> {
        return Set(allFilters.events.map { $0 })
    }
    
    private var userIDs: [String] {
        allFilters.userIDs
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                Form {
                    // MARK: - Heading
                    Section {
                        Text("**Advanced**").font(.title2)
                        VStack(alignment: .leading) {
                            GroupBox {
                                HStack {
                                    if filterPlatform {
                                        Image(systemName: "exclamationmark.triangle.fill").symbolRenderingMode(.palette).foregroundStyle(.black, .yellow)
                                    }
                                    Image(systemName: "apple.logo")
                                    Text("**Drop platform binaries**: Enabling will *drop (not record)* *most* initiating events signed with an Apple certificate unless they target a non-platform process execute or fork event.")
                                    Spacer()
                                    Button(action: {
                                        filterPlatform.toggle()
                                        systemExtensionManager.togglePlatformBinaries()
                                    }) {
                                        Text(!filterPlatform ? "**Enable**" : "Disable")
                                    }.buttonStyle(.borderedProminent).tint(filterPlatform ? .pink : .green).opacity(0.8).padding(.trailing)
                                }
                            }
                        }
                    }
                    
                    Divider().padding(.top)
                    Section {
                        Text("**Artifact filtering**").font(.title2)
                        VStack(alignment: .leading) {
                            GroupBox {
                                Text("These objects have been filtered from view, but have not been dropped by Endpoint Security.").frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            // MARK: Long running process filter
                            //                            Divider()
                            //                            GroupBox {
                            //                                HStack {
                            //                                    Image(systemName: "eye.slash.fill")
                            //                                    Text("**\(!filteringLongRunningProcs ? "Filter" : "Stop filtering") long running processes**: Processes that were started before Project Sutro \(!filteringLongRunningProcs ? "will be" : "have been") filtered from view.")
                            //                                    Spacer()
                            //                                    Button(action: {
                            //                                        filteringLongRunningProcs.toggle()
                            //                                    }) {
                            //                                        Text(filteringLongRunningProcs ? "**Stop**" : "Start")
                            //                                    }.buttonStyle(.borderedProminent).tint(filteringLongRunningProcs ? .pink : .green).opacity(0.8).padding(.trailing)
                            //                                }
                            //                            }
                            
                            // MARK: Event mask
                            GroupBox {
                                HStack {
                                    if eventMaskEnabled {
                                        Image(systemName: "exclamationmark.triangle.fill").symbolRenderingMode(.palette).foregroundStyle(.black, .yellow)
                                    }
                                    Image(systemName: "ellipsis.viewfinder")
                                    Text("**Event mask**: Enabling will filter, but not drop all events you are subscribed to from view. Use the \"Remove\" button to selectively view events.")
                                    Spacer()
                                    Button(action: {
                                        if !eventMaskEnabled {
                                            allFilters.events = getSupportedEventTypesSelectable().filter({
                                                systemExtensionManager.getSimpleEventSubscriptions().contains($0.eventString)
                                            }).map({$0.eventString})
                                        } else {
                                            allFilters.events.removeAll()
                                        }
                                        
                                        eventMaskEnabled.toggle()
                                    }) {
                                        Text(!eventMaskEnabled ? "**Enable**" : "Disable")
                                    }.buttonStyle(.borderedProminent).tint(eventMaskEnabled ? .pink : .green).opacity(0.8).padding(.trailing)
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    
                    // MARK: - Initating process paths
                    if !initiatingProcessPathFilters.isEmpty {
                        Spacer(minLength: 10)
                        Section {
                            Text("Initiating process path").font(.title2).frame(alignment: .leading)
                            Spacer()
                            GroupBox {
                                VStack(alignment: .leading) {
                                    ForEach(Array(initiatingProcessPathFilters), id: \.self) { path in
                                        GroupBox {
                                            HStack {
                                                Text("`\(path)`")
                                                Spacer()
                                                Button(action: {
                                                    allFilters.initiatingPaths.removeAll(where: { $0 == path })
                                                }) {
                                                    Text("**Remove**")
                                                }.buttonStyle(.borderedProminent).tint(.pink).opacity(0.8).padding(.trailing)
                                            }.frame(alignment: .leading)
                                        }
                                    }
                                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                        Divider()
                    }
                    
                    
                    // MARK: Target process paths
                    if !targetPathFilters.isEmpty {
                        Spacer(minLength: 10)
                        Section {
                            Text("Target process path").font(.title2).frame(alignment: .leading)
                            Spacer()
                            GroupBox {
                                VStack(alignment: .leading) {
                                    ForEach(targetPathFilters, id: \.self) { path in
                                        GroupBox {
                                            HStack {
                                                Text("`\(path)`")
                                                Spacer()
                                                Button(action: {
                                                    allFilters.targetPaths.removeAll(where: { $0 == path })
                                                }) {
                                                    Text("**Remove**")
                                                }.buttonStyle(.borderedProminent).tint(.pink).opacity(0.8).padding(.trailing)
                                            }.frame(alignment: .leading)
                                        }
                                    }
                                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                        Divider()
                    }
                    
                    // MARK: - User IDs
                    if !userIDs.isEmpty {
                        Spacer(minLength: 10)
                        Section {
                            Text("User IDs").font(.title2).frame(alignment: .leading)
                            Spacer()
                            GroupBox {
                                VStack(alignment: .leading) {
                                    ForEach(Array(userIDs).sorted(), id: \.self) { user in
                                        GroupBox {
                                            HStack {
                                                Text("`\(user)`")
                                                Spacer()
                                                Button(action: {
                                                    allFilters.userIDs.removeAll(where: { $0 == user })
                                                }) {
                                                    Text("**Remove**")
                                                }.buttonStyle(.borderedProminent).tint(.pink).opacity(0.8).padding(.trailing)
                                            }.frame(alignment: .leading)
                                        }
                                    }
                                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                        Divider()
                    }
                    
                    // MARK: - Endpoint Security events
                    if !eventFilters.isEmpty {
                        Spacer(minLength: 10)
                        Section {
                            Text("Endpoint Security events").font(.title2).frame(alignment: .leading)
                            Spacer()
                            GroupBox {
                                VStack(alignment: .leading) {
                                    ForEach(
                                        Array(eventFilters).sorted(),
                                        id: \.self
                                    ) { event in
                                        GroupBox {
                                            HStack {
                                                Image(systemName: eventStringToImage(from: event))
                                                Text("**`\(event)`**")
                                                Spacer()
                                                Button(action: {
                                                    allFilters.events.removeAll(where: { $0 == event })
                                                }) {
                                                    Text("**Remove**")
                                                }.buttonStyle(.borderedProminent).tint(.pink).opacity(0.8).padding(.trailing)
                                            }.frame(alignment: .leading)
                                        }
                                    }
                                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                        Divider()
                    }
                    
                    
                    
                    
                }.padding(.all)
            }
        }
        .frame(minWidth: 800, minHeight: 600, maxHeight: 800)
        .onAppear {
            systemExtensionManager.requestEventSubscriptions()
            //            allFilters.events = selectableEvents.filter({eventSubs.contains($0.eventString)}).map({$0.eventString})
        }
        Button("Close", action: {
            filteredTelemetryShown.toggle()
        }).buttonStyle(.borderedProminent).tint(.pink).frame(alignment: .center).padding(.all)
    }
    
    
    func delete(at offsets: IndexSet) {
        
    }
}

