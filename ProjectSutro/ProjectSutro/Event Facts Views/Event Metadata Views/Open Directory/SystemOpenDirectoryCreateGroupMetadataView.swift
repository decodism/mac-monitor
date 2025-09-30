//
//  SystemOpenDirectoryCreateGroupMetadataView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 6/28/23.
//

import SwiftUI
import SutroESFramework


struct SystemOpenDirectoryCreateGroupMetadataView: View {
    var esSystemEvent: ESMessage
    
    var odCreateGroupEvent: ESODCreateGroupEvent {
        esSystemEvent.event.od_create_group!
    }
    
    @State private var showAuditTokens: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Event label
            OrangeEventLabelView(message: esSystemEvent)
                .font(.title2)
            
            GroupBox {
                VStack(alignment: .leading) {
                    
                    GroupBox {
                        Label("The process responsible for creating the group.", systemImage: "info.square")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    HStack {
                        Text("\u{2022} **Process name:**")
                        GroupBox {
                            Text("`\(odCreateGroupEvent.instigator_process_name ?? "Unknown")`")
                        }
                    }
                    
                    HStack {
                        Text("\u{2022} **Process signing ID:**")
                        GroupBox {
                            Text("`\(odCreateGroupEvent.instigator_process_signing_id ?? "Unknown")`")
                        }
                    }
                    
                    
                    VStack(alignment: .leading) {
                        Text("\u{2022} **Process path:**")
                        GroupBox {
                            Text("`\(odCreateGroupEvent.instigator_process_path ?? "Unknown")`")
                                .lineLimit(nil)
                                .frame(maxWidth: nil, maxHeight: nil)
                        }
                    }
                    
                    
                    Divider().padding([.top, .bottom])
                    
                    
                    HStack {
                        Text("\u{2022} **Group name:**")
                        GroupBox {
                            Text("`\(odCreateGroupEvent.group_name ?? "Unknown")`")
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("\u{2022} **Node name:**")
                        GroupBox {
                            Text("`\(odCreateGroupEvent.node_name ?? "Unknown")`")
                                .lineLimit(nil)
                                .frame(maxWidth: nil, maxHeight: nil)
                        }
                    }
                    
                    if odCreateGroupEvent.db_path != nil && !odCreateGroupEvent.db_path!.isEmpty {
                        HStack {
                            Text("\u{2022} **Database path:**").font(.title3)
                            GroupBox {
                                Text("`\(odCreateGroupEvent.db_path ?? "Unknown")`")
                            }
                        }
                    }
                    
                    if odCreateGroupEvent.error_code != 0 {
                        HStack {
                            Text("\u{2022} **Error:**")
                            GroupBox {
                                Text("\(try! AttributedString(markdown: odCreateGroupEvent.error_code_human!))")
                            }
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
