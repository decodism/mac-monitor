//
//  FileMetadataSystemEventViews.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 11/16/22.
//

import SwiftUI
import SutroESFramework


struct SystemXattrTableView: View {
    @EnvironmentObject var systemExtensionManager: EndpointSecurityManager
    @Environment(\.openWindow) private var openEventJSON
    
    @EnvironmentObject var userPrefs: UserPrefs
    
    var xattrEvents: [ESMessage]
    @Binding var eventSelection: Set<ESMessage.ID>
    @Binding var allFilters: Filters
    
    var body: some View {
        Table(of: ESMessage.self, selection: $eventSelection) {
            TableColumn("xattr", value: \.event.deleteextattr!.xattr!)
            TableColumn("File path", value: \.event.deleteextattr!.file_path!)
        } rows: {
            ForEach(xattrEvents) { (message: ESMessage) in
                TableRow(message).contextMenu {
                    if message.event.exec != nil {
                        TableExecEventContextMenu(allFilters: $allFilters, message: message)
                            .environmentObject(systemExtensionManager)
                            .environmentObject(userPrefs)
                    } else {
                        TableNonExecContextMenus(allFilters: $allFilters, message: message)
                            .environmentObject(systemExtensionManager)
                            .environmentObject(userPrefs)
                    }
                }
              }
        }
    }
}


struct SystemFileMetadataEventTableViews: View {
    @EnvironmentObject var systemExtensionManager: EndpointSecurityManager
    @Environment(\.openWindow) private var openEventJSON
    
    @EnvironmentObject var userPrefs: UserPrefs
    
    var eventsInScope: [ESMessage]
    @Binding var eventSelection: Set<ESMessage.ID>
    @Binding var allFilters: Filters
    
    var body: some View {
        Divider()
        Section(header: Label("File metadata", systemImage: "filemenu.and.selection").font(.title2)) {
            VStack(alignment: .leading) {
                Text("**Extended attribute deletion**")
                SystemXattrTableView(
                    xattrEvents: eventsInScope
                        .filter {
                            $0.event.deleteextattr?.xattr != nil
                        },
                    eventSelection: $eventSelection,
                    allFilters: $allFilters)
                    .environmentObject(userPrefs)
            }.frame(alignment: .leading)
        }.frame(alignment: .leading)
    }
}
