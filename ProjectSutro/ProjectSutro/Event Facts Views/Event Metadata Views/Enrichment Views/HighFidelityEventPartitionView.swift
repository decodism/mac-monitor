//
//  HighFidelityEventPartitionView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 4/6/23.
//

import SwiftUI
import SutroESFramework


struct FileMetadataGroupTableViews: View {
    @Environment(\.openWindow) private var openEventJSON
    var eventsInScope: [ESMessage]
    @Binding var eventSelection: Set<ESMessage.ID>
    
    var body: some View {
        Divider()
        Section(header: Label("File metadata", systemImage: "filemenu.and.selection").font(.title2)) {
            VStack(alignment: .leading) {
                Text("**Extended attribute deletion**")
                XattrTableView(
                    xattrEvents: eventsInScope
                        .filter { $0.event.deleteextattr != nil },
                    eventSelection: $eventSelection)
            }.frame(alignment: .leading)
        }.frame(alignment: .leading)
    }
}

struct MemoryGroupTableViews: View {
    @Environment(\.openWindow) private var openEventJSON
    var eventsInScope: [ESMessage]
    @Binding var eventSelection: Set<ESMessage.ID>
    
    var body: some View {
        Section(header: Label("Memory", systemImage: "memorychip").font(.title2)) {
            VStack(alignment: .leading) {
                Text("**Memory map object**")
                MemoryMapTableView(
                    mmapEvents: eventsInScope.filter { $0.event.mmap != nil },
                    eventSelection: $eventSelection
                )

            }
        }
    }
}


struct FileMemoryGroupTableViews: View {
    @Environment(\.openWindow) private var openEventJSON
    var eventsInScope: [ESMessage]
    @Binding var eventSelection: Set<ESMessage.ID>
    
    @Binding var fileViewSelected: Bool
    @Binding var memoryViewSelected: Bool
    
    
    var body: some View {
        if fileViewSelected {
            HStack {
                Divider()
                Section {
                    VStack(alignment: .leading) {
                        Label("File", systemImage: "note.text.badge.plus").font(.title2)
                        FileTableView(fileEvents: eventsInScope.filter({ $0.event.create != nil }), eventSelection: $eventSelection)
                    }
                }
            }
        }
        
        if memoryViewSelected {
            Divider()
            Section {
                VStack(alignment: .leading) {
                    Label("Memory", systemImage: "memorychip").font(.title2)
                    VStack(alignment: .leading) {
                        Text("**Memory map object**")
                        MemoryMapTableView(mmapEvents: eventsInScope.filter { $0.event.mmap != nil }, eventSelection: $eventSelection)
                    }
                }
                
            }
        }
    }
}


struct ProcessGroupTableViews: View {
    @Environment(\.openWindow) private var openEventJSON
    var eventsInScope: [ESMessage]
    @Binding var viewFork: Bool
    @Binding var viewExec: Bool
    @Binding var eventSelection: Set<ESMessage.ID>
    
    var body: some View {
        if viewExec || viewFork {
            Divider()
            Section(header: Label("Process", systemImage: "square.stack.3d.down.forward").font(.title2)) {
                HStack {
                    if viewExec {
                        VStack(alignment: .leading) {
                            Text("**Execution**")
                            ProcessExecTableView(execEvents: eventsInScope.filter { $0.event.exec != nil }, eventSelection: $eventSelection)
                        }
                    }
                    if viewFork {
                        VStack(alignment: .leading) {
                            Text("**Fork**")
                            ProcessForkTableView(forkEvents: eventsInScope.filter { $0.event.fork != nil }, eventSelection: $eventSelection)
                        }
                    }
                    
                }
            }
        }
    }
}
