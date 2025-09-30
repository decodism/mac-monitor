//
//  XPCMetadataView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 1/17/23.
//

import SwiftUI
import SutroESFramework

// MARK: - XPC details view
struct XPCMetadataView: View {
    var execEvent: ESProcessExecEvent
    var envVars: [String]
    
    var serviceName: String {
        (
            envVars.filter({ $0.hasPrefix("XPC_SERVICE_NAME") }).first ?? "None"
        ).replacing("XPC_SERVICE_NAME=", with: "")
    }
    
    var body: some View {
        if serviceName != "None" && serviceName != "0" {
            VStack(alignment: .leading) {
                Text("\u{2022} **XPC service name**").font(.title3)
                GroupBox {
                    Text("`\(serviceName)`").font(.title3)
                }
            }
            
        }
    }
}
