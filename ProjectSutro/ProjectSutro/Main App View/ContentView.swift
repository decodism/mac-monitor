//
//  ContentView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 7/5/22.
//

import SwiftUI
import CoreData
import SystemExtensions
import SutroESFramework
import OSLog
import AppKit


/// Handles requesting app reboots and showing a TCC access alert.
class AgentCloseController: ObservableObject {
    @Published var showAlert = false
    
    /// Should the TCC alert be shown?
    func toggleQuitAlert() {
        showAlert.toggle()
    }
    
    /// Request that the app be re-launched over XPC by the persistent Security Extension
    func quitAgent(esm: EndpointSecurityManager) {
        esm.tccRequestAppReboot()
        NSApp.terminate(nil)
    }
}

// Custom button style for alert
struct AlertButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color.red.opacity(0.8) : Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}


// MARK: Primary App View
/// The primary view for Mac Monitor. Consisting of a toolbar and two tables.
///
/// In this view  the user can interact with Mac Monitor's primary functionality,
struct EventView: View {
    /// Get the system apperance
    @Environment(\.colorScheme) var colorMode
    
    /// Open a new "Event metadata" window
    @Environment(\.openWindow) private var eventFactsWindow
    
    /// Track everything going on with System Events and the Security Extension
    @EnvironmentObject var systemExtensionManager: EndpointSecurityManager
    
    /// Load user preferences from ``UserDefaults``
    @EnvironmentObject var userPrefs: UserPrefs
    
    
    
    /// Query Core Data for our System Events
    ///
    /// Events  (``ESMessage``) are inserted one-by-one in the order dispatched by Endpoint Security.
    /// Our fetch request gets events in decending order by the ``mach_time`` entity key
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(key: "mach_time", ascending: false)
    ]) var coreDataEvents: FetchedResults<ESMessage>
    
    
    
    /// Is a system trace occuring?
    @Binding var recordingEvents: Bool
    @State private var isBlinking: Bool = false
    
    /// Should the "System Security Unified" table be shown?
    @Binding var unifiedViewSelected: Bool
    /// Should the "Process Execution" table be shown?
    @Binding var processExecSelected: Bool
    /// Should the SwiftUI mini-chart be shown
    @Binding var viewMiniChart: Bool
    
    /// Are we filtering long processes which executed before Mac Monitor was started?
    ///
    // TODO: Implement long running process filtering
    @Binding var filteringLongRunningProcs: Bool
    
    
    
    /// The currently selected System Event (i.e. table row)
    @Binding var eventSelection: Set<ESMessage.ID>
    
    /// The text to filter by in the context search field
    @Binding var filterText: String
    
    /// The query the user wants to filter the ``context`` field by.
    @State var submitedQuery: String = ""
    
    
    
    /// Implements our ability to request app re-launches over XPC by the Security Extension.
    ///
    /// This is done by ``AgentCloseController``.
    @StateObject private var agentTerminate = AgentCloseController()
    
    
    @State private var filterSelection = Set<String>()
    @State private var filteredTelemetryShown: Bool = false
    
    
    /// Track all filters offered by Mac Monitor
    @Binding var allFilters: Filters
    /// Is the event mask enabled?
    @Binding var eventMaskEnabled: Bool
    
    /// Should we ask the user to confirm before clearing System Events?
    @State private var confirmClear: Bool = false
    
    /// Should we filter out *most* events initiated by a platform binary?
    @State private var filterPlatform: Bool = false
    
    /// Should events be displayed in ascending order?
    // TODO: Fix sorting events
    @State private var ascending: Bool = false
    
    /// This more *rare* alert will be displayed when the the user launches the app.
    ///
    /// Usually what we'll do is check on app-launch and disable the start button.
    // TODO: Refactor TCC alerting
    @State private var tccAlert: Bool = false
    
    
    /// The filtered System Events to be made avalible to the primary app tables
    private var filteredCoreDataEvents: [ESMessage] {
        let lineageResolver = ProcessLineageResolver(events: Array(coreDataEvents))
        return coreDataEvents.lazy.filter { event in
            return isEventFiltered(
                event: event,
                filteringLongRunningProcs: filteringLongRunningProcs,
                filterText: filterText.lowercased(),
                allFilters: allFilters,
                systemExtensionManager: systemExtensionManager,
                lineageResolver: lineageResolver
            )
        }
    }
    
    /// The string displaying the number of System Events collected over the course of the trace
    private var eventCountString: AttributedString  {
        if allFilters.totalFilters() + (filteringLongRunningProcs ? 1 : 0) == 0 {
            return try! AttributedString(markdown: "**Events** `\(coreDataEvents.count)`")
        } else {
            return try! AttributedString(markdown: "**Events** `\(filteredCoreDataEvents.count)` (`\(String(format: "%.2f", Double(filteredCoreDataEvents.count)/Double(!coreDataEvents.isEmpty ? coreDataEvents.count : 1)*100.0))%`)")
        }
    }
    
    /// Request that events be cleared from the PSC and reset the UI
    public func clearSystemEventsUI() {
        var sentinel: Bool = false
        if recordingEvents {
            recordingEvents = false
            
            sentinel = true
        }
        
        systemExtensionManager.cleanup()
        systemExtensionManager.stopRecordingEvents()
        systemExtensionManager.coreDataContainer.clearSystemEvents()
        
        if sentinel {
            recordingEvents = true
            systemExtensionManager.startRecordingEvents()
            sentinel = false
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Core Data System Events (replaces legacy Swift Array of events)
            SystemEventsTableView(
                messagesInScope: filteredCoreDataEvents,
                unifiedViewSelected: $unifiedViewSelected,
                viewExec: $processExecSelected,
                viewMiniChart: $viewMiniChart,
                ascending: $ascending,
                allFilters: $allFilters,
                messageSelections: $eventSelection
            )
            .environmentObject(systemExtensionManager)
            .environmentObject(userPrefs)
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                if #unavailable(macOS 14) {
                    VenturaStartButton(recordingEvents: $recordingEvents, confirmClear: $confirmClear)
                        .environmentObject(systemExtensionManager)
                        .environmentObject(agentTerminate)
                        .environmentObject(userPrefs)
                } else {
                    SonomaStartButton(recordingEvents: $recordingEvents, confirmClear: $confirmClear)
                        .environmentObject(systemExtensionManager)
                        .environmentObject(agentTerminate)
                        .environmentObject(userPrefs)
                }
                
                // MARK: - Stop recording events
                Button(action: {
                    recordingEvents = false
                    Task {
                        systemExtensionManager.cleanup()
                        systemExtensionManager.stopRecordingEvents()
                    }
                }) {
                    Text("Stop")
                        .bold()
                        .padding([.leading, .trailing], 5)
                }
                .disabled(!recordingEvents)
            }
                
            // MARK: - Clear System Events
            ToolbarItem(placement: .principal) {
                Button(action: {
                    if userPrefs.lifecycleWarnBeforeClear {
                        confirmClear.toggle()
                    } else {
                        clearSystemEventsUI()
                    }
                }) {
                    Label("Clear", systemImage: "clear")
                        .labelStyle(.titleAndIcon)
                        .padding([.leading, .trailing], 5)
                }
                .disabled(coreDataEvents.isEmpty)
                
                
            }
            
            ToolbarItem(placement: .principal) {
                Button {
                    filteredTelemetryShown.toggle()
                } label: {
                    Text("Filters `\(allFilters.totalFilters() + (filteringLongRunningProcs ? 1 : 0) + (filterPlatform ? 1 : 0))`")
                        .padding([.leading, .trailing], 5)
                }.sheet(isPresented: $filteredTelemetryShown, content: {
                    FilterView(
                        allFilters: $allFilters,
                        filteredTelemetryShown: $filteredTelemetryShown,
                        filterSelection: $filterSelection,
                        filteringLongRunningProcs: $filteringLongRunningProcs,
                        eventMaskEnabled: $eventMaskEnabled,
                        filterPlatform: $filterPlatform
                    )
                    .environmentObject(systemExtensionManager)
                })
            }
            
            ToolbarItemGroup(placement: .status) {
                Button(action: {
                    viewMiniChart.toggle()
                }) {
                    Label("Mini-chart", systemImage: "chart.bar")
                        .padding([.leading, .trailing], 5)
                        .labelStyle(.iconOnly)
                }
                .disabled(unifiedViewSelected ? false : true)
                
                Text(eventCountString)
                    .padding([.trailing])
                
                Circle()
                    .fill(recordingEvents ? Color.green : Color.red)
                    .shadow(color: Color.green, radius: 0.5)
                    .opacity(recordingEvents ? 0.85 : 0)
                    .scaleEffect(recordingEvents ? 1.25 : 1)
                    .animation(.linear(duration: 0.3), value: recordingEvents)
                    .help(recordingEvents ? "Recording system events" : "Not recording system events")
                    .padding(.trailing)
                
                Spacer()
            }
        }
        .searchable(text: $filterText, prompt: "Filter by context")
//        .onSubmit(of: .search) {
//            submitedQuery = filterText
//        }
        .onAppear {
            if !CommandLine.arguments.contains("--deactive-security-extension") {
                systemExtensionManager.activateSystemExtension()
                
                switch(systemExtensionManager.connectionResult) {
                case .notPermitted:
                    os_log("💾 [ES new client result] TCC FDA required!")
                    tccAlert = true
                    break
                case .internalSubsystem:
                    os_log("😥 [ES new client result] internalSubsystem error!")
                    break
                case .invalidArgument:
                    os_log("🤔 [ES new client result] invalidArgument error!")
                    break
                case .notEntitled:
                    os_log("🔒 [ES new client result] ES entitlement not found!")
                    break
                case .tooManyClients:
                    os_log("🍬 [ES new client result] tooManyClients error!")
                    break
                case .success:
                    os_log("⚡️ [ES new client result] Success!")
                    break
                case .notPrivileged:
                    os_log("😬 [ES new client result] notPrivileged!")
                    break
                case .waiting:
                    os_log("🥱 [ES new client result] waiting...")
                    break
                default:
                    os_log("🤔 [ES new client result] Unknown error!")
                    break
                }
            }
            
            // We're not recording events at app launch
            recordingEvents = false
        }
        .alert("The Security Extension does not have full disk access!", isPresented: $tccAlert) {
            Button("Open System Settings") {
                tccAlert = false
                NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!)
            }
        }
    }
}

