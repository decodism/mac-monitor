//
//  SystemSessionGroupTableView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 9/7/25.
//

import SwiftUI
import SutroESFramework

struct SystemEventGroupTableViews: View {
    @EnvironmentObject var systemExtensionManager: EndpointSecurityManager
    @Binding var allFilters: Filters
    
    @State private var selectedMessages: Set<ESMessage.ID> = []
    @State private var ascending: Bool = false
    
    var selectedMessage: ESMessage
    
    /// Process groups:
    /// - `gid`
    /// - `session_id`
    var processGroup: [ESMessage]
    var sessionGroup: [ESMessage]
    
    /// Extract the target process name
    private var processName: String {
        if let exec = selectedMessage.event.exec {
            return exec.target.executable?.name ?? ""
        } else if let fork = selectedMessage.event.fork {
            return fork.child.executable?.name ?? ""
        }
        
        return selectedMessage.process.executable?.name ?? ""
    }
    
    var body: some View {
        Form {
            VStack(alignment: .leading) {
                VSplitView {
                    if !processGroup.isEmpty {
                        Section {
                            VStack(alignment: .leading) {
                                Text("**Process group (\(processGroup.count))**")
                                
                                if #available(macOS 14, *) {
                                    CustomizableSystemProcessExecTableView(
                                        messages: processGroup,
                                        simple: true,
                                        messageSelections: $selectedMessages,
                                        allFilters: $allFilters,
                                        ascending: $ascending
                                    ).environmentObject(systemExtensionManager)
                                } else {
                                    SystemProcessExecTableView(
                                        messages: processGroup,
                                        simple: true,
                                        messageSelections: $selectedMessages,
                                        allFilters: $allFilters,
                                        ascending: $ascending
                                    ).environmentObject(systemExtensionManager)
                                }
                            }
                        }
                    }
                    
                    if !sessionGroup.isEmpty {
                        Section {
                            VStack(alignment: .leading) {
                                Text("**Session group (\(sessionGroup.count))**")
                                    .padding(.top)
                                
                                if #available(macOS 14, *) {
                                    CustomizableSystemProcessExecTableView(
                                        messages: sessionGroup,
                                        simple: true,
                                        messageSelections: $selectedMessages,
                                        allFilters: $allFilters,
                                        ascending: $ascending
                                    ).environmentObject(systemExtensionManager)
                                } else {
                                    SystemProcessExecTableView(
                                        messages: sessionGroup,
                                        simple: true,
                                        messageSelections: $selectedMessages,
                                        allFilters: $allFilters,
                                        ascending: $ascending
                                    ).environmentObject(systemExtensionManager)
                                }
                            }
                        }
                    }
                }
            }.padding(.all)
        }
    }
}
