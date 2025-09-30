//
//  SystemGetTaskMetadataView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 4/4/23.
//

import SwiftUI
import SutroESFramework

struct SystemGetTaskMetadataView: View {
    var esSystemEvent: ESMessage
    @State private var showAuditTokens: Bool = false
    @State private var showTargetAuditTokens: Bool = false
    
    var event: ESGetTaskEvent {
        esSystemEvent.event.get_task!
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Event label
            GetTaskEventLabelView(message: esSystemEvent)
                .font(.title2)
            
            GroupBox {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\u{2022} **Type:**")
                            .padding([.leading], 5.0)
                        GroupBox {
                            Text("`\(event.type!)`")
                                .frame(alignment: .leading)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack{
                        Text("\u{2022} **Process name:**")
                            .padding([.leading], 5.0)
                        GroupBox {
                            Text("`\(event.process_name ?? "")`")
                                .frame(alignment: .leading)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading) {
                        Text("\u{2022} **Process path:**")
                            .padding([.leading], 5.0)
                        GroupBox {
                            Text("`\(event.process_path ?? "")`")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let procSigningId = event.process_signing_id {
                        HStack {
                            Text("\u{2022} **Signing ID:**")
                                .padding([.leading], 5.0)
                            GroupBox {
                                Text("`\(procSigningId)`")
                                    .frame(alignment: .leading)
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
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
                    Button("**Target audit tokens**") {
                        showTargetAuditTokens.toggle()
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
            }.buttonStyle(.borderedProminent).tint(.pink).opacity(0.8).padding(.trailing).padding(.bottom)
        }.sheet(isPresented: $showTargetAuditTokens) {
            AuditTokenView(audit_token: event.process_audit_token!)
            Button("**Dismiss**") {
                showTargetAuditTokens.toggle()
            }.buttonStyle(.borderedProminent).tint(.pink).opacity(0.8).padding(.trailing).padding(.bottom)
        }
    }
}
