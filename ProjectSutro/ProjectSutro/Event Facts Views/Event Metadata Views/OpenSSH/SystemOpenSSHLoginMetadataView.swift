//
//  SystemOpenSSHLoginMetadataView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 1/17/23.
//

import SwiftUI
import SutroESFramework

struct SystemOpenSSHLoginMetadataView: View {
    var esSystemEvent: ESMessage
    @State private var showAuditTokens: Bool = false
    
    private var event: ESOpenSSHLoginEvent {
        esSystemEvent.event.openssh_login!
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Event label
            OpenSSHLoginEventLabelView(message: esSystemEvent)
                .font(.title2)
            
            GroupBox {
                VStack(alignment: .leading) {
                    HStack {
                        Label("**Username:**", systemImage: "person.fill")
                        GroupBox {
                            Text("`\(event.user_name ?? "Unknown")`")
                        }
                    }
                    
                    HStack {
                        Text("\u{2022} **Success:**")
                        GroupBox {
                            Text("`\(event.success ? "Yes" : "No")`")
                        }
                    }
                    
                    HStack {
                        Text("\u{2022} **Result type:**")
                        GroupBox {
                            Text("`\(event.result_type!)`")
                        }
                    }
                    
                    HStack {
                        Text("\u{2022} **Source Address:**")
                        VStack(alignment: .leading) {
                            GroupBox {
                                Text("`\(event.source_address_type ?? "Unknown")`")
                            }
                            
                            GroupBox {
                                Text("`\(event.source_address ?? "Unknown")`")
                            }
                        }
                        
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Divider()
            
            Label("**Context items**", systemImage: "folder.badge.plus")
                .font(.title2)
                .padding([.leading], 5.0)
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
