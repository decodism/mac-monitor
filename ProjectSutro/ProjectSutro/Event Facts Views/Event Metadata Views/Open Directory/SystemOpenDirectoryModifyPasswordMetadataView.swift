//
//  SystemModifyPasswordMetadataView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 6/23/23.
//

import SwiftUI
import SutroESFramework


struct SystemOpenDirectoryModifyPasswordMetadataView: View {
    var esSystemEvent: ESMessage
    @State private var showAuditTokens: Bool = false
    
    private var event: ESODModifyPasswordEvent {
        esSystemEvent.event.od_modify_password!
    }

    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Event label
            OpenDirectoryModifyPasswordEventLabelView(message: esSystemEvent)
                .font(.title2)
            
            GroupBox {
                VStack(alignment: .leading) {
                    
                    GroupBox {
                        Label("The process responsible for the password modification.", systemImage: "info.square")
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
                        Text("\u{2022} **Account type:**")
                        GroupBox {
                            Text("`\(event.account_type ?? "Unknown")`")
                        }
                    }

                    HStack {
                        Text("\u{2022} **Account name:**")
                        GroupBox {
                            Text("`\(event.account_name ?? "Unknown")`")
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("\u{2022} **Node name:**")
                        GroupBox {
                            Text("`\(event.node_name ?? "Unknown")`")
                                .lineLimit(nil)
                                .frame(maxWidth: nil, maxHeight: nil)
                        }
                    }

                    if event.db_path != nil && !event.db_path!.isEmpty {
                        HStack {
                            Text("\u{2022} **Database path:**")
                            GroupBox {
                                Text("`\(event.db_path!)`")
                            }
                        }
                    }
                    
                    if event.error_code != 0 {
                        HStack {
                            Text("\u{2022} **Error:**")
                            GroupBox {
                                Text("`\(try! AttributedString(markdown: event.error_code_human!))`")
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
