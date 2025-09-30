//
//  SystemFileRenameMetadataView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 2/17/23.
//

import SwiftUI
import SutroESFramework

struct SystemFileRenameMetadataView: View {
    @EnvironmentObject var systemExtensionManager: EndpointSecurityManager
    var esSystemEvent: ESMessage
    @State private var showAuditTokens: Bool = false
    
    var event: ESFileRenameEvent {
        esSystemEvent.event.rename!
    }
    
    private var filesNotQuarantined: [String] {
        if !event.archive_files_not_quarantined!.isEmpty {
            return event.archive_files_not_quarantined!.split(separator: "[::]").map({String($0)})
        }
        return []
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Event label
            FileRenameEventLabelView(message: esSystemEvent)
                .font(.title2)
            
            GroupBox {
                if !event.archive_files_not_quarantined!.isEmpty {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "bolt.trianglebadge.exclamationmark.fill")
                                .font(Font.system(size: 10, weight: .bold))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.purple)
                            Text("**Inflated files not quarantined:**")
                        }.padding([.leading], 5.0)
                        
                        GroupBox {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.black, .yellow)
                                    Text("The files listed here should have been quarantined when an archive was inflated, but were **not**. Investigate how these files were created.")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .lineLimit(20)
                                }
                                Divider()
                                ForEach(filesNotQuarantined, id: \.self) { item in
                                    GroupBox {
                                        Text("`\(String(item.trimmingPrefix("file://")))`")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                } else if event.file_name!.hasSuffix(".app") {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "hand.raised.app")
                                .font(Font.system(size: 10, weight: .bold))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.red)
                                .help("An unquarantined application bundle was inflated as a result of an unarchive operation")
                            Text("**Application inflated:**")
                        }.padding([.leading], 5.0)
                        
                        GroupBox {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.black, .yellow)
                                    Text("An application bundle was inflated as a result of an unarchive operation. Identify in context where this app came from. If the original archive was quarantined this should have been as well, but was not.")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .lineLimit(20)
                                }
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("\u{2022} **Destination file name:**")
                            .padding([.leading], 5.0)
                        GroupBox {
                            Text("`\(event.file_name!)`")
                        }
                        FileQuarantineStatusLabelView(isQuarantined: Int(event.is_quarantined))
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading) {
                        Text("\u{2022} **Destination Path:**")
                            .padding([.leading], 5.0)
                        HStack {
                            GroupBox {
                                if event.type != "EXISTING_FILE" {
                                    Text("`\(event.destination_path!.appending("/\(event.file_name!)"))`")
                                } else {
                                    Text("`\(event.destination_path!)`")
                                }
                            }
                            Spacer()
                            if event.type != "EXISTING_FILE" && FileManager.default.fileExists(atPath: event.destination_path!) {
                                Image(systemName: "checkmark.square")
                                    .help("This file exists")
                                    .font(Font.system(size: 10, weight: .bold))
                                    .padding(.trailing)
                            } else if event.type == "EXISTING_FILE" && FileManager.default.fileExists(atPath: event.destination_path!.appending("/\(event.file_name!)")) {
                                Image(systemName: "checkmark.square")
                                    .help("This file exists")
                                    .font(Font.system(size: 10, weight: .bold))
                                    .padding(.trailing)
                            } else {
                                Image(systemName: "trash").help("This file no longer exists")
                                    .padding(.trailing)
                                    .font(Font.system(size: 10, weight: .bold))
                            }
                            
                        }
                        
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    VStack(alignment: .leading) {
                        Text("\u{2022} **Source Path:**")
                            .padding([.leading], 5.0)
                        GroupBox {
                            VStack {
                                Text("`\(event.source_path!)`")
                            }.frame(maxWidth: .infinity, alignment: .leading)
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
