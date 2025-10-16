//
//  PropertyListView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 1/17/23.
//

import SwiftUI
import SutroESFramework

struct PropertyListView: View {
    var selectedRCEvent: ESMessage
    
    private var event: ESLaunchItemAddEvent {
        selectedRCEvent.event.btm_launch_item_add!
    }
    
    var body: some View {
        Section("**Target property list**") {
            ScrollView {
                if let plist_contents = event.item.plist_contents {
                    Text(plist_contents)
                        .monospaced()
                        .foregroundColor(.white)
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 10.0
                        )
                        .scrollContentBackground(.hidden)
                        .textSelection(.enabled)
                }
                
            }.background(.black)
        }
    }
}
