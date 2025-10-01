//
//  SystemRemoteThreadCreateMetadataView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 4/4/23.
//

import SwiftUI
import SutroESFramework

struct SystemRemoteThreadCreateMetadataView: View {
    var esSystemEvent: ESMessage
    @State private var showAuditTokens: Bool = false
    @State private var showTargetAuditTokens: Bool = false
    
    private var event: ESRemoteThreadCreateEvent {
        esSystemEvent.event.remote_thread_create!
    }
    
    private var targetName: String {
        event.target.executable?.name ?? "Unknown"
    }
    
    private var targetPath: String {
        event.target.executable?.path ?? "Unknown"
    }
    
    private var targetSigningId: String? {
        event.target.signing_id
    }
    
    private var targetAuditToken: String {
        event.target.audit_token_string
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Event label
            RemoteThreadCreateEventLabelView(message: esSystemEvent)
                .font(.title2)
            
            GroupBox {
                VStack(alignment: .leading) {
                    
                    if let state = event.thread_state {
                        HStack {
                            Text("\u{2022} Thread state:")
                                .bold()
                                .padding([.leading], 5.0)
                            GroupBox {
                                Text(state)
                                    .monospaced()
                                    .frame(alignment: .leading)
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    
                    HStack {
                        Text("\u{2022} Target process name:")
                            .bold()
                            .padding([.leading], 5.0)
                        GroupBox {
                            Text(targetName)
                                .monospaced()
                                .frame(alignment: .leading)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading) {
                        Text("\u{2022} Target process path:")
                            .bold()
                            .padding([.leading], 5.0)
                        GroupBox {
                            Text(targetPath)
                                .monospaced()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let signingId = targetSigningId, !signingId.isEmpty {
                        HStack {
                            Text("\u{2022} Signing ID:")
                                .bold()
                                .padding([.leading], 5.0)
                            GroupBox {
                                Text(signingId)
                                    .monospaced()
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
            AuditTokenView(audit_token: targetAuditToken)
            Button("**Dismiss**") {
                showTargetAuditTokens.toggle()
            }.buttonStyle(.borderedProminent).tint(.pink).opacity(0.8).padding(.trailing).padding(.bottom)
        }
    }
}

