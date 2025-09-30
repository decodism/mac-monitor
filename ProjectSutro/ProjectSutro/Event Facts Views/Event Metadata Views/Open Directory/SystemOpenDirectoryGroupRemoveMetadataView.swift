//
//  SystemGroupRemoveMetadataView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 6/27/23.
//

import SwiftUI
import SutroESFramework



struct RespGroupRemoveProcView: View {
    var esSystemEvent: ESMessage
    
    private var event: ESODGroupRemoveEvent {
        esSystemEvent.event.od_group_remove!
    }
    
    var body: some View {
        GroupBox {
            Label("The process responsible for removing a member from the group.", systemImage: "info.square")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        HStack {
            Text("\u{2022} **Process name:**").font(.title3)
            GroupBox {
                Text("`\(event.instigator_process_name ?? "Unknown")`")
            }
        }
        
        HStack {
            Text("\u{2022} **Process signing ID:**").font(.title3)
            GroupBox {
                Text("`\(event.instigator_process_name ?? "Unknown")`")
            }
        }
        
        
        VStack(alignment: .leading) {
            Text("\u{2022} **Process path:**").font(.title3)
            GroupBox {
                Text("`\(event.instigator_process_path ?? "Unknown")`")
                    .lineLimit(nil)
                    .frame(maxWidth: nil, maxHeight: nil)
            }
        }
    }
}

struct SystemOpenDirectoryGroupRemoveMetadataView: View {
    var esSystemEvent: ESMessage
    @State private var showAuditTokens: Bool = false
    
    private var event: ESODGroupRemoveEvent {
        esSystemEvent.event.od_group_remove!
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Event label
            OrangeEventLabelView(message: esSystemEvent)
                .font(.title2)
            
            GroupBox {
                VStack(alignment: .leading) {
                    
                    RespGroupRemoveProcView(esSystemEvent: esSystemEvent)
                    
                    Divider().padding([.top, .bottom])
                    
                    Text("\u{2022} **Group name:**")
                        .padding([.leading], 5.0)
                    GroupBox {
                        Text("`\(event.group_name ?? "Unknown")`")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Text("\u{2022} **Member type:**")
                        .padding([.leading], 5.0)
                    GroupBox {
                        Text("`\(event.member ?? "Unknown")`")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("\u{2022} **Node name:**")
                            .padding([.leading], 5.0)
                        GroupBox {
                            Text("`\(event.node_name ?? "Unknown")`")
                                .lineLimit(nil)
                                .frame(maxWidth: nil, maxHeight: nil)
                        }
                    }
                    
                    if event.db_path != nil && !event.db_path!.isEmpty {
                        Text("\u{2022} **Database Path:**")
                            .padding([.leading], 5.0)
                        GroupBox {
                            Text("`\(event.db_path!)`")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    if event.error_code != 0 {
                        Text("\u{2022} **Error:**")
                            .padding([.leading], 5.0)
                        GroupBox {
                            Text("`\(try! AttributedString(markdown: event.error_code_human!))`").font(.title3).frame(maxWidth: .infinity, alignment: .leading)
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

