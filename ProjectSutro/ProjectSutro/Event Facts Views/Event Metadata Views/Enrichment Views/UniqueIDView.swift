//
//  UniqueIDView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 1/20/23.
//

import SwiftUI

struct UniqueIDView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                Section {
                    Text("**Process unique ID**").font(.title2)
                    Divider()
                    GroupBox {
//                        Text("`\(audit_token)`")
                    }
                }
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(.all)
    }
}
