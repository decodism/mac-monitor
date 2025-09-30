//
//  EventSubscriptionsSettingsView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 5/18/23.
//

import SwiftUI
import SutroESFramework


struct AddSubscriptionsView: View {
    @EnvironmentObject var systemExtensionManager: EndpointSecurityManager
    @Binding var showSubscriptionSheet: Bool
    @Binding var allFilters: Filters
    @Binding var eventMaskEnabled: Bool
    
    @State private var selectableEvents: [SelectableEvent] = getSupportedEventTypesSelectable()
    private var eventSubscriptions: [String] { systemExtensionManager.getSimpleEventSubscriptions() }
    
    var body: some View {
        Form {
            VStack(alignment: .leading) {
                Section {
                    Text("Select events to subscribe to").font(.title3)
                    Text("The Security Extension will be notified when macOS generates these security events.").font(.headline)
                }
                
                Divider()
                
                Section("**Total events remaining: `\(selectableEvents.lazy.count - eventSubscriptions.lazy.count)`**") {
                    List {
                        ForEach(selectableEvents.lazy.filter({ !eventSubscriptions.contains($0.eventString) }), id: \.self) { selectableEvent in
                            GroupBox {
                                HStack {
                                    Toggle(isOn: $selectableEvents.first(where: { $0.eventString.wrappedValue == selectableEvent.eventString })!.selected) {
                                        HStack {
                                            Image(systemName: eventStringToImage(from: selectableEvent.eventString))
                                            Text(selectableEvent.eventString)
                                        }
                                    }
                                    Spacer()
                                    Button {
                                        NSWorkspace.shared.open(URL(string:"https://developer.apple.com/documentation/endpointsecurity/es_event_type_t/\(selectableEvent.eventString)")!)
                                    } label: {
                                        Image(systemName: "arrowshape.turn.up.backward.fill").help("Open developer docs.")
                                    }
                                }
                            }
                            
                        }
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                Divider()
                
            }
            
            HStack {
                Button("Subscribe to \(selectableEvents.filter( { $0.selected } ).count) events") {
                    // MARK: Step #1 in subscribing to Endpoint Security events
                    for selectedEvent in selectableEvents.filter( { $0.selected } ) {
                        if eventMaskEnabled && !allFilters.events.contains(selectedEvent.eventString) {
                            allFilters.events.append(selectedEvent.eventString)
                        }
                        systemExtensionManager.puntEventToSubscribe(eventString: selectedEvent.eventString)
                    }
                    
                    // Refresh the event subscriptions
                    systemExtensionManager.requestEventSubscriptions()
                    // Now close the sheet
                    withAnimation {
                        showSubscriptionSheet.toggle()
                    }
                }.disabled(selectableEvents.filter( { $0.selected } ).isEmpty)
                
                Button("**Cancel**") {
                    showSubscriptionSheet.toggle()
                }.buttonStyle(.borderedProminent).tint(.pink).opacity(0.8)
            }.frame(maxWidth: .infinity, alignment: .center)
        }.frame(minWidth: 500, idealWidth: 600, maxWidth: 700, minHeight: 400, maxHeight: 2000, alignment: .topLeading).padding(.all)
    }
}


struct ESSubscriptionsView: View {
    @EnvironmentObject var systemExtensionManager: EndpointSecurityManager
    @State private var showSubscriptionSheet: Bool = false
    @Binding var allFilters: Filters
    @Binding var eventMaskEnabled: Bool
    
    var eventSubscriptions: [String] { systemExtensionManager.getSimpleEventSubscriptions() }
    
    var body: some View {
        Form {
            VStack(alignment: .leading) {
                Section {
                    GroupBox {
                        HStack {
                            Image(systemName: "apple.logo")
                            VStack(alignment: .leading) {
                                Text("**Endpoint Security event subscriptions (`\(eventSubscriptions.count)`)**").font(.title3)
                                Text("The Secuirty Extension is subscribed to the following events. Depending on your mute / filter sets you'll see these events in event window.").font(.callout)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                    }
                }
                
                Divider()
                
                Section {
                    ScrollView {
                        if eventSubscriptions.isEmpty {
                            GroupBox {
                                VStack(alignment: .leading) {
                                    Text("You're not subscribed to any events!").font(.title3)
                                }.frame(maxWidth: .infinity, alignment: .leading)
                            }
                        } else {
                            ForEach(eventSubscriptions, id: \.self) { event in
                                GroupBox {
                                    HStack {
                                        Image(systemName: eventStringToImage(from: event))
                                        Text("**`\(event)`**")
                                        Spacer()
                                        Button {
                                            NSWorkspace.shared.open(URL(string:"https://developer.apple.com/documentation/endpointsecurity/es_event_type_t/\(event)")!)
                                        } label: {
                                            Image(systemName: "arrowshape.turn.up.backward.fill").help("Open developer docs.")
                                        }
                                        Button(action: {
                                            // MARK: Step #1 in unsubscribing from events
//                                            if eventMaskEnabled {
//                                                allFilters.events = allFilters.events.filter({
//                                                    $0 != event
//                                                })
//                                            }
                                            
                                            systemExtensionManager.puntEventToUnsubscribe(eventString: event)
                                            systemExtensionManager.requestEventSubscriptions()
                                        }) {
                                            Text("**Unsubscribe**")
                                        }.buttonStyle(.borderedProminent).tint(.pink).opacity(0.8).padding(.trailing)
                                    }
                                }
                            }
                        }
                        
                    }
                }.sheet(isPresented: $showSubscriptionSheet) {
                    AddSubscriptionsView(showSubscriptionSheet: $showSubscriptionSheet, allFilters: $allFilters, eventMaskEnabled: $eventMaskEnabled).environmentObject(systemExtensionManager)
                }
                
                Divider()
            }
            Section {
                HStack {
                    Button("**Subscribe to events**") {
                        withAnimation {
                            showSubscriptionSheet.toggle()
                        }
                    }
                    Button("Unsubscribe from all") {
                        withAnimation {
                            // MARK: Step #1 in unsubscribing from events
                            for event in eventSubscriptions {
                                systemExtensionManager.puntEventToUnsubscribe(eventString: event)
                            }
                            
                            systemExtensionManager.requestEventSubscriptions()
                        }
                    }.buttonStyle(.borderedProminent).tint(.pink).opacity(0.8).help("Event subscriptions drive the user experience. Unsubscribing from all events will remove all events from collection.")
                    
                    Button("**Reset subscriptions**") {
                        for event in systemExtensionManager.getCoreEvents() {
                            systemExtensionManager.puntEventToSubscribe(eventString: event)
                        }
                        systemExtensionManager.requestEventSubscriptions()
                    }.disabled(!eventSubscriptions.isEmpty).buttonStyle(.borderedProminent).tint(.green).opacity(0.8).help("Unsubscribe from all events to reset to default subscriptions.")
                }.frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .onAppear {
            systemExtensionManager.requestEventSubscriptions()
        }
    }
}


struct TargetedEventsView: View {
    @EnvironmentObject var systemExtensionManager: EndpointSecurityManager
    var path: ESMutedPath
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(path.events, id: \.self) { event in
                GroupBox {
                    HStack {
                        Text("\t\u{2022} **`\(event)`**").frame(alignment: .leading)
                        Spacer()
                        Button(action: {
                            // MARK: Step #1 in unmuting path per event
                            systemExtensionManager.puntPathToUnmute(pathToUnmute: path.path, type: path.type, events: [event])
                            systemExtensionManager.requestMutedPaths()
                        }) {
                            Text("**Unmute**")
                        }.buttonStyle(.borderedProminent).tint(.orange).opacity(0.8).padding(.trailing)
                    }
                }.padding([.leading, .trailing])
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}



