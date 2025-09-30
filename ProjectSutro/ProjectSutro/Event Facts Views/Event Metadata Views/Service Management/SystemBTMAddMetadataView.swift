//
//  SystemBTMAddMetadataView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 1/17/23.
//

import SwiftUI
import SutroESFramework

struct SystemBTMAddMetadataView: View {
    var esSystemEvent: ESMessage
    @State private var showAuditTokens: Bool = false
    
    var btm_launch_item_add: ESLaunchItemAddEvent? {
        esSystemEvent.event.btm_launch_item_add
    }
    
    var type: String? {
        btm_launch_item_add?.type
    }
    
    var isLegacy: Bool? {
        btm_launch_item_add?.is_legacy
    }
    
    var isManaged: Bool? {
        btm_launch_item_add?.is_managed
    }
    
    var fileName: String? {
        btm_launch_item_add?.file_name
    }
    
    var filePath: String {
        String(btm_launch_item_add?.file_path?.trimmingPrefix("file://") ?? "")
    }
    
    
    var appProcPath: String? {
        btm_launch_item_add?.app_process_path
    }
    
    var appProcTeamId: String? {
        btm_launch_item_add?.app_process_team_id
    }
    
    var appProcSigningId: String? {
        btm_launch_item_add?.app_process_signing_id
    }
    
    
    var instigatingProcPath: String? {
        btm_launch_item_add?.instigating_process_path
    }
    
    var instigatingProcTeamId: String? {
        btm_launch_item_add?.instigating_process_team_id
    }
    
    var instigatingProcSigningId: String? {
        btm_launch_item_add?.instigating_process_signing_id
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Event label
            BTMLaunchItemAddEventLabelView(message: esSystemEvent)
                .font(.title2)
            
            GroupBox {
                VStack(alignment: .leading) {
                    
                    if let type = type {
                        HStack {
                            Text("\u{2022} **Type:**")
                            GroupBox {
                                Text("`\(String(type))`")
                            }
                        }
                    }
                    
                    
                    if let isLegacy = isLegacy,
                       let isManaged = isManaged {
                        HStack {
                            Text("\u{2022} **Is legacy:**")
                            GroupBox {
                                Text(
                                    "`\(String(isLegacy))`"
                                )
                            }
                            Text("\u{2022} **Is managed:**")
                            GroupBox {
                                Text(
                                    "`\(String(isManaged))`"
                                )
                            }
                        }
                    }
                    
                    if let fileName = fileName {
                        HStack {
                            Text("\u{2022} **File name:**")
                            GroupBox {
                                Text("`\(fileName)`")
                                
                            }
                        }
                    }
                    
                    HStack {
                        Text("\u{2022} **Path:**")
                        GroupBox {
                            Text(
                                "`\(filePath)`"
                            )
                            .lineLimit(5)
                            
                        }
                    }
                    
                    if let appProcPath = appProcPath,
                       !appProcPath.isEmpty {
                        Divider()
                        HStack {
                            Text("\u{2022} **App path:**")
                            GroupBox {
                                Text(
                                    "`\(appProcPath)`"
                                )
                                .lineLimit(20)
                                
                            }
                        }
                        
                        
                        if let appProcTeamId = appProcTeamId {
                            HStack {
                                Text("\u{2022} **App team ID:**")
                                GroupBox {
                                    Text("`\(appProcTeamId)`")
                                        .lineLimit(20)
                                    
                                }
                            }
                        }
                        
                        
                        if let appProcSigningId = appProcSigningId {
                            HStack {
                                Text("\u{2022} **App ID:**")
                                GroupBox {
                                    Text("`\(appProcSigningId)`")
                                        .lineLimit(20)
                                    
                                }
                            }
                        }
                        
                        
                    }
                    
                    if let instigatingProcPath = instigatingProcPath,
                       !instigatingProcPath.isEmpty {
                        Divider()
                        HStack {
                            Text("\u{2022} **Instigating process path:**")
                            GroupBox {
                                Text("`\(instigatingProcPath)`")
                                    .lineLimit(20)
                                
                            }
                        }
                        
                        if let instigatingProcTeamId = instigatingProcTeamId,
                           !instigatingProcTeamId.isEmpty {
                            HStack {
                                Text("\u{2022} **Instigating team ID:**")
                                GroupBox {
                                    Text("`\(instigatingProcTeamId)`")
                                        .lineLimit(20)
                                    
                                }
                            }
                        }
                        
                        if let instigatingProcSigningId = instigatingProcSigningId,
                           !instigatingProcSigningId.isEmpty {
                            HStack {
                                Text("\u{2022} **Instigating signing ID:**")
                                GroupBox {
                                    Text("`\(instigatingProcSigningId)`")
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
