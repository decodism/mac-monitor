//
//  SystemAuthorizationPetitionMetadataView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 6/27/23.
//

import SwiftUI
import SutroESFramework


struct AuthProcsView: View {
    var event: ESAuthorizationPetitionEvent
    
    var body: some View {
        VStack(alignment: .leading) {
            if event.instigator_process_signing_id != event.petitioner_process_signing_id {
                HStack {
                    Text("\u{2022} **Instigator process name:**")
                    GroupBox {
                        Text("`\(event.instigator_process_name ?? "Unknown")`")
                    }
                }
                VStack(alignment: .leading) {
                    Text("\u{2022} **Instigator process path:**")
                    GroupBox {
                        Text("`\(event.instigator_process_path ?? "Unknown")`")
                            .font(.title3).frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(30)
                    }
                }
                HStack {
                    Text("\u{2022} **Instigator process signing ID:**")
                    GroupBox {
                        Text("`\(event.instigator_process_signing_id ?? "Unknown")`")
                    }
                }
                
                
                Divider().padding(.vertical, 10)
                
                HStack {
                    Text("\u{2022} **Petitioner process name:**")
                    GroupBox {
                        Text("`\(event.petitioner_process_name ?? "Unknown")`")
                    }
                }
                VStack(alignment: .leading) {
                    Text("\u{2022} **Petitioner process path:**")
                    GroupBox {
                        Text("`\(event.petitioner_process_path ?? "Unknown")`")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(30)
                    }
                }
                HStack {
                    Text("\u{2022} **Petitioner process signing ID:**")
                    GroupBox {
                        Text("`\(event.petitioner_process_signing_id ?? "Unknown")`")
                    }
                }
                
                Divider().padding(.vertical, 10)
            } else {
                GroupBox {
                    Label("The processes petitioning and instigating are the same:", systemImage: "info.square")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                HStack {
                    Text("\u{2022} **Process name:**")
                    GroupBox {
                        Text("`\(event.instigator_process_name ?? "Unknown")`")
                    }
                }
                VStack(alignment: .leading) {
                    Text("\u{2022} **Process path:**")
                    GroupBox {
                        Text("`\(event.instigator_process_path ?? "Unknown")`")
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                HStack {
                    Text("\u{2022} **Process signing ID:**")
                    GroupBox {
                        Text("`\(event.instigator_process_signing_id ?? "Unknown")`")
                    }
                }
                Divider().padding(.vertical, 10)
            }
        }
    }
}


struct SystemAuthorizationPetitionMetadataView: View {
    var esSystemEvent: ESMessage
    @State private var showAuditTokens: Bool = false
    
    
    var event: ESAuthorizationPetitionEvent {
        esSystemEvent.event.authorization_petition!
    }
    
    var flagsList: [String] {
        if let flags = event.flags {
            return flags.contains("[::]") ? flags.components(separatedBy: "[::]") : [flags]
        }
        return []
    }

    var rightsList: [String] {
        if let rights = event.rights {
            return rights.contains("[::]") ? rights.components(separatedBy: "[::]") : [rights]
        }
        return []
    }

    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Event label
            OrangeEventLabelView(message: esSystemEvent)
                .font(.title2)
            
            GroupBox {
                VStack(alignment: .leading) {
                    AuthProcsView(event: event)
                    
                    Text("**Flags:**")
                    GroupBox {
                        Label("Flags are defined as part of the Security framework in: `Authorization/Authorization.h`", systemImage: "info.square")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    GroupBox {
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(flagsList, id: \.self) { flag in
                                    GroupBox {
                                        Text("`\(flag)`")
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    Text("**Rights requested:**").font(.title3)
                    GroupBox {
                        Label("Default right definitions: `/System/Library/Security/authorization.plist` and runtime authorization database: `/var/db/auth.db`.", systemImage: "info.square")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    GroupBox {
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(rightsList, id: \.self) { right in
                                    GroupBox {
                                        Text("`\(right)`")
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding([.leading, .trailing], 10)
            }
            
            Divider().padding(.vertical, 10)
            
            Label("**Context items**", systemImage: "folder.badge.plus").font(.title2).padding([.leading], 5.0)
            GroupBox {
                HStack {
                    Button("**Audit tokens**") {
                        showAuditTokens.toggle()
                    }
                }.frame(maxWidth: .infinity, alignment: .center).padding(.all)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showAuditTokens) {
            VStack {
                AuditTokenView(
                    audit_token: esSystemEvent.process.audit_token_string,
                    responsible_audit_token: esSystemEvent.process.responsible_audit_token_string,
                    parent_audit_token: esSystemEvent.process.parent_audit_token_string
                )
                Button("Dismiss") {
                    showAuditTokens.toggle()
                }.padding(.bottom)
            }
        }
    }
}
