//
//  SystemGroupAddMetadataView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 6/27/23.
//

import SwiftUI
import SutroESFramework


struct SystemOpenDirectoryGroupAddMetadataView: View {
    var esSystemEvent: ESMessage
    
    @State private var showAuditTokens: Bool = false
    
    var event: ESODGroupAddEvent {
        esSystemEvent.event.od_group_add!
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Event label
            OrangeEventLabelView(message: esSystemEvent)
                .font(.title2)
            
            GroupBox {
                VStack(alignment: .leading) {
                    GroupBox {
                        Label("The process responsible for adding a member to the group.", systemImage: "info.square")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    HStack {
                        Text("\u{2022} **Process name:**")
                        GroupBox {
                            Text("`\(event.instigator_process_name ?? "Unknown")`")
                        }
                    }
                    
                    HStack {
                        Text("\u{2022} **Process signing ID:**")
                        GroupBox {
                            Text("`\(event.instigator_process_name ?? "Unknown")`")
                        }
                    }
                    
                    
                    VStack(alignment: .leading) {
                        Text("\u{2022} **Process path:**")
                        GroupBox {
                            Text("`\(event.instigator_process_path ?? "Unknown")`")
                                .lineLimit(nil)
                                .frame(maxWidth: nil, maxHeight: nil)
                        }
                    }
                    
                    
                    Divider().padding([.top, .bottom])
                    
                    HStack {
                        Text("\u{2022} **Group name:**")
                            .padding([.leading], 5.0)
                        GroupBox {
                            Text("`\(event.group_name ?? "Unknown")`")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Text("\u{2022} **Member type:**")
                            .padding([.leading], 5.0)
                        GroupBox {
                            Text("`\(event.member ?? "Unknown")`")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading) {
                        Text("\u{2022} **Node name:**")
                            .padding([.leading], 5.0)
                        GroupBox {
                            Text("`\(event.node_name ?? "Unknown")`")
                                .lineLimit(nil)
                                .frame(maxWidth: nil, maxHeight: nil)
                        }
                    }
                    
                    if event.error_code != 0 {
                        HStack {
                            Text("\u{2022} **Error code:**")
                                .padding([.leading], 5.0)
                            GroupBox {
                                Text("`\(event.error_code_human!)`")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    
                    HStack {
                        Text("\u{2022} **Database path:**")
                            .padding([.leading], 5.0)
                        GroupBox {
                            Text("`\(event.db_path ?? "Unknown")`")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
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

