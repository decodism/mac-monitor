//
//  EntitlementsView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 11/16/22.
//

import SwiftUI
import SutroESFramework

struct SystemDangerousEntitlementView: View {
    var message: ESMessage
    @State var visible: Bool = false
    
    private var event: ESProcessExecEvent {
        message.event.exec!
    }
    
    var body: some View {
        VStack {
            HStack {
                if event.target.rootless {
                    Image(systemName: "lock.open.trianglebadge.exclamationmark").padding(.leading)
                    Text("`com.apple.rootless.*`  ")
                }
                
                if event.target.allow_jit {
                    Image(systemName: "lock.open.trianglebadge.exclamationmark").padding(.leading)
                    Text("`com.apple.security.cs.allow-jit`  ")
                    
                }
                
                if event.target.get_task_allow {
                    Image(systemName: "lock.open.trianglebadge.exclamationmark").padding(.leading)
                    Text("`com.apple.security.get-task-allow`  ")
                }
                
                if event.target.skip_lv {
                    Image(systemName: "lock.open.trianglebadge.exclamationmark").padding(.leading)
                    Text("`com.apple.security.cs.disable-library-validation`  ")
                }
            }.background(Rectangle().fill(Color.orange.opacity(0.3)))
        }
    }
}
