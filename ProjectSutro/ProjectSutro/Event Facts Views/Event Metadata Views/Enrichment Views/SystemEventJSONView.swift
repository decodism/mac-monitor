//
//  SystemEventJSONView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 1/17/23.
//

import SwiftUI
import SutroESFramework

struct SystemEventJSONView: View {
    var selectedMessage: ESMessage
    @State private var jsonText: String = ""
    
    var body: some View {
        ScrollView {
            Text(jsonText)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 10.0)
                .scrollContentBackground(.hidden)
                .textSelection(.enabled)
        }
        .background(.black)
        .onAppear {
            jsonText = ProcessHelpers.eventToPrettyJSON(value: selectedMessage)
        }
    }
}
