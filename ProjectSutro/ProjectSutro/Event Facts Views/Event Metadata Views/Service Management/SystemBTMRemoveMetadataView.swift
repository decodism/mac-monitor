//
//  SystemBTMRemoveMetadataView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 1/17/23.
//

import SwiftUI
import SutroESFramework

struct SystemBTMRemoveMetadataView: View {
    var esSystemEvent: ESMessage
    @State private var showAuditTokens: Bool = false
    
    private var event: ESLaunchItemRemoveEvent {
        esSystemEvent.event.btm_launch_item_remove!
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Event label
            BTMLaunchItemRemoveEventLabelView(message: esSystemEvent)
                .font(.title2)
            
            GroupBox {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\u{2022} **Type:**")
                        GroupBox {
                            Text("`\(event.type!)`")
                        }
                    }
                    
                    HStack {
                        Text("\u{2022} **Is legacy:**")
                        GroupBox {
                            Text("`\(event.is_legacy ? "Yes" : "No")`")
                            
                        }
                        Text("\u{2022} **Is managed:**")
                        GroupBox {
                            Text("`\(event.is_managed ? "Yes" : "No")`")
                            
                        }
                    }
                    
                    HStack {
                        Text("\u{2022} **File name:**")
                        GroupBox {
                            Text("`\(event.file_name!)`")
                            
                        }
                    }
                    
                    HStack {
                        Text("\u{2022} **Path:**")
                        GroupBox {
                            Text("`\(String(event.file_path!.trimmingPrefix("file://")))`")
                                .lineLimit(5)
                            
                        }
                    }
                    
                    if event.app_process_path != nil && !event.app_process_path!.isEmpty {
                        Divider()
                        HStack {
                            Text("\u{2022} **App path:**")
                            GroupBox {
                                Text("`\(String(event.app_process_path!.trimmingPrefix("file://")))`")
                                    .lineLimit(20)
                                
                            }
                        }
                        
                        if event.app_process_team_id != nil && !event.app_process_team_id!.isEmpty {
                            HStack {
                                Text("\u{2022} **App team ID:**")
                                GroupBox {
                                    Text("`\(event.app_process_team_id!)`")
                                        .lineLimit(20)
                                    
                                }
                            }
                        }
                        
                        if event.app_process_signing_id != nil && !event.app_process_signing_id!.isEmpty {
                            HStack {
                                Text("\u{2022} **App ID:**")
                                GroupBox {
                                    Text("`\(event.app_process_signing_id!)`")
                                        .lineLimit(20)
                                    
                                }
                            }
                        }
                    }
                    
                    if event.instigating_process_path != nil && !event.instigating_process_path!.isEmpty {
                        Divider()
                        HStack {
                            Text("\u{2022} **Instigating process path:**")
                            GroupBox {
                                Text("`\(event.instigating_process_path!)`")
                                    .lineLimit(20)
                                
                            }
                        }
                        
                        if event.instigating_process_team_id != nil && !event.instigating_process_team_id!.isEmpty {
                            HStack {
                                Text("\u{2022} **Instigating team ID:**")
                                GroupBox {
                                    Text("`\(event.instigating_process_team_id!)`")
                                        .lineLimit(20)
                                    
                                }
                            }
                        }
                        
                        if event.instigating_process_signing_id != nil && !event.instigating_process_signing_id!.isEmpty {
                            HStack {
                                Text("\u{2022} **Instigating signing ID:**")
                                GroupBox {
                                    Text("`\(event.app_process_signing_id!)`")
                                        .lineLimit(20)
                                    
                                }
                            }
                        }
                        
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                
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
