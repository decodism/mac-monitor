//
//  SystemProcessEntitlementsView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 1/17/23.
//

import SwiftUI
import SutroESFramework

struct SystemProcessEntitlementsView: View {
    var message: ESMessage
    
    var body: some View {
        if let execEvent: ESProcessExecEvent = message.event.exec {
            Divider()
            Section("**Process entitlements**") {
                // If exec or mmap event let's enrich
                HStack {
                    if execEvent.target.skip_lv {
                        Text(" `com.apple.security.cs.disable-library-validation` ").background(Capsule().fill(.red).opacity(0.3))
                    }
                    
                    if execEvent.target.get_task_allow {
                        Text(" `com.apple.security.get-task-allow` ").background(Capsule().fill(.red).opacity(0.3))
                    }
                    
                    if execEvent.target.rootless {
                        Text(" `com.apple.rootless.*` ").background(Capsule().fill(.red).opacity(0.3))
                    }
                    
                    if execEvent.target.allow_jit {
                        Text(" `com.apple.security.cs.allow-jit` ").background(Capsule().fill(.red).opacity(0.3))
                    }
                    
                }.textSelection(.enabled).padding(1)
            }
        }
    }
}
