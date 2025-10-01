//
//  SwiftUIView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 6/28/23.
//

import SwiftUI
import SutroESFramework


struct Result: Identifiable, Hashable {
    let id = UUID()
    var rightName: String
    var ruleClass: String
    var granted: Bool

    init(from description: String) {
        let components = description.components(separatedBy: ", ")
        let rightNameComponent = components.first(where: { $0.contains("Right name") })
        let ruleClassComponent = components.first(where: { $0.contains("Rule class") })
        let grantedComponent = components.first(where: { $0.contains("Granted") })

        self.rightName = rightNameComponent?.components(separatedBy: ": ").last ?? ""
        self.ruleClass = ruleClassComponent?.components(separatedBy: ": ").last ?? ""
        self.granted = Bool(grantedComponent?.components(separatedBy: ": ").last ?? "") ?? false
    }
}

struct AuthJudegeProcsView: View {
    var event: ESAuthorizationJudgementEvent
    
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
                            .frame(maxWidth: .infinity, alignment: .leading)
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


struct SystemAuthorizationJudgementMetadataView: View {
    var esSystemEvent: ESMessage
    @State private var showAuditTokens: Bool = false
    
    var event: ESAuthorizationJudgementEvent {
        esSystemEvent.event.authorization_judgement!
    }
    
    var resultsList: [String] {
        if let results = event.results {
            return results.contains("[::]") ? results.components(separatedBy: "[::]") : [results]
        }
        return []
    }
    
    var results: [Result] {
        return resultsList.map { Result(from: $0) }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Event label
            OrangeEventLabelView(message: esSystemEvent)
                .font(.title2)
            
            GroupBox {
                VStack(alignment: .leading) {
                    AuthJudegeProcsView(event: event)
                    
                    Text("**Results from authorization petition:**")
                    Table(results) {
                        TableColumn("Right name") { result in
                            Text("`\(result.rightName)`")
                        }
                        TableColumn("Rule class") { result in
                            Text("`\(result.ruleClass)`")
                        }
                        TableColumn("Granted") { result in
                            Text("`\(result.granted ? "Yes" : "No")`")
                        }
                    }
                    .frame(maxWidth: nil, minHeight: 100.0, maxHeight: nil, alignment: .leading)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding([.leading, .trailing], 10)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
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
