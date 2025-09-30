//
//  SystemLinkEventMetadataView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 4/3/23.
//

import SwiftUI
import SutroESFramework

struct SystemLinkEventMetadataView: View {
    var esSystemEvent: ESMessage
    @State private var showAuditTokens: Bool = false
    
    private var event: ESLinkEvent {
        esSystemEvent.event.link!
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Event label
            FileLinkEventLabelView(message: esSystemEvent)
                .font(.title2)
            
            GroupBox {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("\u{2022} **Source file path:**")
                            .padding([.leading], 5.0)
                        GroupBox {
                            Text("`\(event.source_file_path!)`")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading) {
                        Text("\u{2022} **Destination file path:**")
                            .padding([.leading], 5.0)
                        GroupBox {
                            Text("`\(event.target_file_path!)`")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }.frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("\u{2022} **Source file name:**")
                            .padding([.leading], 5.0)
                        GroupBox {
                            Text("`\(event.source_file_name!)`")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "arrow.right")
                    VStack(alignment: .leading) {
                        Text("\u{2022} **Destination file name:**")
                            .padding([.leading], 5.0)
                        GroupBox {
                            Text("`\(event.target_file_name!)`")
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
