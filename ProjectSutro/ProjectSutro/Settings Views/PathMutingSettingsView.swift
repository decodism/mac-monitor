//
//  PathMutingSettingsView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 5/18/23.
//

import SwiftUI
import SutroESFramework
import OSLog


enum MuteMode: String, CaseIterable, Identifiable {
    case globalPathPrefix, globalPathLiteral, targetPathPrefix, targetPathLiteral, processAuditToken
    var id: Self { self }
}


struct PathUnmuteView: View {
    @EnvironmentObject var systemExtensionManager: EndpointSecurityManager
    var jsonPath: String
    
    var decodedJSONPath: ESMutedPath { decodePathJSON(pathJSON: jsonPath)! }
    
    var humanType: String {
        switch(decodedJSONPath.type) {
        case "ES_MUTE_PATH_TYPE_PREFIX":
            return "Initiating prefix"
        case "ES_MUTE_PATH_TYPE_LITERAL":
            return "Initiating literal"
        case "ES_MUTE_PATH_TYPE_TARGET_PREFIX":
            return "Target prefix"
        case "ES_MUTE_PATH_TYPE_TARGET_LITERAL":
            return "Target literal"
        default:
            return "Unknown"
        }
    }
    
    var body: some View {
        HStack {
            switch(decodedJSONPath.type) {
            case "ES_MUTE_PATH_TYPE_PREFIX":
                Text(" **\(humanType)** ").background(RoundedRectangle(cornerRadius: 5).fill(.red.opacity(0.3))).frame(alignment: .leading)
            case "ES_MUTE_PATH_TYPE_LITERAL":
                Text(" **\(humanType)** ").background(RoundedRectangle(cornerRadius: 5).fill(.orange.opacity(0.3))).frame(alignment: .leading)
            case "ES_MUTE_PATH_TYPE_TARGET_PREFIX":
                Text(" **\(humanType)** ").background(RoundedRectangle(cornerRadius: 5).fill(.green.opacity(0.3))).frame(alignment: .leading)
            case "ES_MUTE_PATH_TYPE_TARGET_LITERAL":
                Text(" **\(humanType)** ").background(RoundedRectangle(cornerRadius: 5).fill(.blue.opacity(0.3))).frame(alignment: .leading)
            default:
                Text(" **Unknown** ").background(RoundedRectangle(cornerRadius: 5).fill(.black.opacity(0.3))).frame(alignment: .leading)
            }
            
            Text("`\(decodePathJSON(pathJSON: jsonPath)!.path)`")
            Spacer()
            Button(action: {
                // MARK: Step #1 in unmuting paths
                systemExtensionManager.puntPathToUnmute(pathToUnmute: decodePathJSON(pathJSON: jsonPath)!.path, type: decodedJSONPath.type, events: decodePathJSON(pathJSON: jsonPath)!.events)
                systemExtensionManager.requestMutedPaths()
            }) {
                Text("**Unmute**")
            }.buttonStyle(.borderedProminent).tint(.pink).opacity(0.8).padding(.trailing)
        }
        
    }
}

struct MutedPathsScrollView: View {
    @EnvironmentObject var systemExtensionManager: EndpointSecurityManager
    var mutedPaths: [String] { systemExtensionManager.simpleGetMutedPaths() }
    @State private var searchText: String = ""
    
    var body: some View {
        if !mutedPaths.isEmpty {
            ScrollView {
                ForEach(mutedPaths, id: \.self) { jsonPath in
                    // MARK: - Prefix path muting
                    GroupBox {
                        PathUnmuteView(jsonPath: jsonPath).environmentObject(systemExtensionManager)
                        DisclosureGroup("Targeted events **(\(decodePathJSON(pathJSON: jsonPath)!.eventCount))**") {
                            TargetedEventsView(path: decodePathJSON(pathJSON: jsonPath)!).environmentObject(systemExtensionManager)
                        }
                    }
                }
                
            }.frame(alignment: .leading).textSelection(.enabled)
        } else {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill").symbolRenderingMode(.palette).foregroundStyle(.black, .yellow)
                Text("There are no paths muted at the Endpoint Security level! Expect high event volume / noise to signal ratio!").font(.title3)
            }
        }
    }
}

struct ESMutingSheet: View {
    @EnvironmentObject var systemExtensionManager: EndpointSecurityManager
    @Binding var showPathMuteAddSheet: Bool
    
    // MARK: Path muting settingss
    @State private var selectedMuteMode: MuteMode = .globalPathPrefix
    @Binding var pathToMute: String
    @State private var muteType: String = ""
    @State var eventToggle: Bool = true
    
    @State private var selectableEvents: [SelectableEvent] = getAllEventTypesSelectable()
    private var eventSubscriptions: [String] { systemExtensionManager.getSimpleEventSubscriptions() }
    
    private var typeMuteMode: es_mute_path_type_t {
        switch(selectedMuteMode) {
        case .globalPathPrefix:
            return ES_MUTE_PATH_TYPE_PREFIX
        case .globalPathLiteral:
            return ES_MUTE_PATH_TYPE_LITERAL
        case .targetPathPrefix:
            return ES_MUTE_PATH_TYPE_TARGET_PREFIX
        case .targetPathLiteral:
            return ES_MUTE_PATH_TYPE_TARGET_LITERAL
        default:
            return ES_MUTE_PATH_TYPE_TARGET_LITERAL
        }
    }
    
    var body: some View {
        Form {
            Section {
                Text("**Path mute properties**").font(.title3)
                GroupBox {
                    HStack {
                        Image(systemName: "info.square")
                        Text("To mute a executable path for all ES events click \"Mute path\". To mute a path only for the selected events click \"Mute path events\"").font(.callout).padding(.trailing)
                    }
                }
                Spacer(minLength: 10.0)
                TextField("Binary target path", text: $pathToMute)
                Picker("Mute by", selection: $selectedMuteMode) {
                    Text("Initiating executable path prefix").tag(MuteMode.globalPathPrefix)
                    Text("Initiating executable path literal").tag(MuteMode.globalPathLiteral)
                    Text("Target path prefix").tag(MuteMode.targetPathPrefix)
                    Text("Target path literal").tag(MuteMode.targetPathLiteral)
                }
            }
            Divider()
            Section("**Endpoint Security client properties**") {
                GroupBox {
                    Text("The matching executable image path will only be muted for these events ES events. Please note `AUTH` events have no effect in this context. **First** subscribe to the events you're interested in.").frame(maxWidth: .infinity).padding(.trailing)
                }
                
                List {
                    ForEach(selectableEvents.lazy.filter({
                        if eventSubscriptions.contains($0.eventString) {
                            if selectedMuteMode == .globalPathLiteral || selectedMuteMode == .globalPathPrefix {
                                return true
                            } else {
                                if allowedTargetPathEvents.contains($0.es_event_type) {
                                    return true
                                }
                                return false
                            }
                        }
                        return false
                    }) , id: \.self) { selectableEvent in
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
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            HStack {
                Button("Mute path") {
                    // MARK: Step #1 in muting paths (globally)
                    // Send off the request and clear the field
                    // Gather the events the user wants to mute this path for
                    systemExtensionManager.puntPathToMute(pathToMute: pathToMute, muteCase: typeMuteMode, pathEvents: [])
                    pathToMute = ""
                    
                    // Refresh the muted parhs
                    systemExtensionManager.requestMutedPaths()
                    // Now close the sheet
                    withAnimation {
                        showPathMuteAddSheet.toggle()
                    }
                }.disabled(pathToMute.isEmpty)
                Button("Mute path events") {
                    // MARK: Step #1 in muting paths (for events)
                    systemExtensionManager.puntPathToMute(pathToMute: pathToMute, muteCase: typeMuteMode, pathEvents: Array(selectableEvents.filter({ $0.selected })).map(\.eventString))
                    pathToMute = ""
                    
                    // Refresh the muted parhs
                    systemExtensionManager.requestMutedPaths()
                    // Now close the sheet
                    withAnimation {
                        showPathMuteAddSheet.toggle()
                    }
                }.disabled(pathToMute.isEmpty || Array(selectableEvents.filter({ $0.selected })).isEmpty)
                Button("**Cancel**") {
                    withAnimation {
                        showPathMuteAddSheet.toggle()
                    }
                }.buttonStyle(.borderedProminent).tint(.pink).opacity(0.8)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading).padding(.all).transition(.scale)
        .onAppear {
            systemExtensionManager.requestEventSubscriptions()
        }
    }
}


struct ESMutingTabView: View {
    @EnvironmentObject var systemExtensionManager: EndpointSecurityManager
    @State private var selectedPath = Set<String>()
    
    @State private var showPathMuteAddSheet: Bool = false
    @State private var unmuteAllAlert: Bool = false
    
    
    // MARK: Path muting settingss
    @Binding var pathToMute: String
    
//    var mutedPaths: [String] { systemExtensionManager.simpleGetMutedPaths() }
    
    var body: some View {
        Form {
            VStack {
                Section {
                    VStack(alignment: .leading) {
                        GroupBox {
                            VStack(alignment: .leading) {
                                Label("**Unified path muting**", systemImage: "globe").font(.title3)
                                Divider()
                                Text("Paths added here will cause events matching the initiating executable image or target path to be muted at the endpoint security level. Additionally, paths can target a given emitted event (usually `AUTH` events). Muting is a powerful feature at the ES level that will help improve performance during heavy traces.").font(.callout)
                            }
                        }
                        Divider()
                        MutedPathsScrollView().environmentObject(systemExtensionManager)
                    }
                }.sheet(isPresented: $showPathMuteAddSheet) {
                    ESMutingSheet(showPathMuteAddSheet: $showPathMuteAddSheet, pathToMute: $pathToMute).frame(minWidth: 650, maxWidth: 650, minHeight: 500).padding(.all)
                }
                Divider()
                HStack {
                    Button("**Add path to mute**") {
                        withAnimation {
                            showPathMuteAddSheet.toggle()
                        }
                    }
                    
                    Button(action: {
                        unmuteAllAlert.toggle()
                    }) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill").symbolRenderingMode(.palette).foregroundStyle(.black, .yellow)
                            Text("Unmute all paths")
                        }
                    }
                    .buttonStyle(.borderedProminent).tint(.pink).opacity(0.8)
                    .alert("Path mute warning!", isPresented: $unmuteAllAlert, actions: {
                        Button("Changed my mind!", role: nil, action: {
                            unmuteAllAlert.toggle()
                        })
                        Button("Continue", role: nil, action: {
                            // MARK: Step #1 in unmuting paths
                            for jsonPath in systemExtensionManager.simpleGetMutedPaths() {
                                let decodedPath = decodePathJSON(pathJSON: jsonPath)!
                                systemExtensionManager.puntPathToUnmute(pathToUnmute: decodedPath.path, type: decodedPath.type, events: decodedPath.events)
                            }
                            systemExtensionManager.requestMutedPaths()
                            
                            unmuteAllAlert.toggle()
                        })
                    }, message: {
                        Text("Are you sure you want to unmute all paths? This will dramaticlly increase event count.")
                    })
                    .disabled(systemExtensionManager.simpleGetMutedPaths().isEmpty)
                    
                    Button("Reset") {
                        systemExtensionManager.resetMuteSetToDefaultRCSet()
                        systemExtensionManager.requestMutedPaths()
                    }.buttonStyle(.borderedProminent).tint(.green).opacity(0.8).disabled(!systemExtensionManager.simpleGetMutedPaths().isEmpty).help("When there are no paths muted you have the option to reset to our default mute set.")
                    
                    Button("Export") {
                        let muteFileURL: URL? = showMuteSavePanel()
                        if muteFileURL != nil {
                            do {
                                try systemExtensionManager.simpleGetMutedPaths().joined(separator: "\n").write(to: muteFileURL!, atomically: true, encoding: String.Encoding.utf8)
                            } catch {
                                os_log("Failed to write path mute file. \(error.localizedDescription)")
                            }
                        }
                    }.disabled(systemExtensionManager.simpleGetMutedPaths().isEmpty).help("Export the paths muted to JSON.")
                }
            }
        }.onAppear {
            systemExtensionManager.requestMutedPaths()
        }
    }
}
