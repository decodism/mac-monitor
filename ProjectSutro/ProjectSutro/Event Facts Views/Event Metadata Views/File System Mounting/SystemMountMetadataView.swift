//
//  SystemMountMetadataView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 1/17/23.
//

import SwiftUI
import SutroESFramework

struct SystemMountMetadataView: View {
    var esSystemEvent: ESMessage
    @State private var showAuditTokens: Bool = false
    
    private var event: ESMountEvent {
        esSystemEvent.event.mount!
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Event label
            MountEventLabelView(message: esSystemEvent)
                .font(.title2)
            
            
            GroupBox {
                VStack(alignment: .leading) {
                    HStack {
                        Label("**Owner:**", systemImage: "person.fill")
                            .padding([.leading], 5.0)
                        GroupBox {
                            Text("`\(event.owner_uid_human!) (\(event.owner_uid))`")
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Text("\u{2022} **Source path:**")
                        GroupBox {
                            Text("`\(event.source_name!)`").lineLimit(10)
                        }
                        Text("\u{2022} **ID:**")
                        GroupBox {
                            Text("`\(event.fs_id!)`")
                        }
                    }
                    HStack {
                        Text("\u{2022} **Mount directory:**")
                        GroupBox {
                            Text("`\(event.mount_directory!)`")
                                .lineLimit(10)
                        }
                    }
                    HStack {
                        Text("\u{2022} **Type:**")
                        GroupBox {
                            Text("`\(event.type_name!)`")
                        }
                        Text("\u{2022} **Total files:**")
                        GroupBox {
                            Text("`\(event.total_files)`")
                        }
                    }
                    
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Divider()
            
            Label("**Context items**", systemImage: "folder.badge.plus").font(.title2).padding([.leading], 5.0)
            GroupBox {
                HStack {
                    Button("**Audit tokens**") {
                        showAuditTokens.toggle()
                    }
                }.frame(maxWidth: .infinity, alignment: .center).padding(.all)
            }
        }.sheet(isPresented: $showAuditTokens) {
            AuditTokenView(
                audit_token: esSystemEvent.process.audit_token_string,
                responsible_audit_token: esSystemEvent.process.responsible_audit_token_string,
                parent_audit_token: esSystemEvent.process.parent_audit_token_string
            )
            Button("**Dismiss**") {
                showAuditTokens.toggle()
            }.padding(.bottom)
        }
    }
}


