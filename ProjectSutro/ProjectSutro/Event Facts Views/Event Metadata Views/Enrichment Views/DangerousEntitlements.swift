//
//  DangerousEntitlements.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 4/6/23.
//

import SwiftUI
import SutroESFramework


struct DangerousEntitlementView: View {
    var message: ESMessage
    @State var visible: Bool = false
    
    var body: some View {
        if let execEvent = message.event.exec {
            VStack {
                HStack {
                    if execEvent.target.rootless {
                        Image(systemName: "lock.open.trianglebadge.exclamationmark").padding(.leading)
                        Text("`com.apple.rootless.*`  ")
                    }
                    
                    if execEvent.target.allow_jit {
                        Image(systemName: "lock.open.trianglebadge.exclamationmark").padding(.leading)
                        Text("`com.apple.security.cs.allow-jit`  ")
                        
                    }
                    
                    if execEvent.target.get_task_allow {
                        Image(systemName: "lock.open.trianglebadge.exclamationmark").padding(.leading)
                        Text("`com.apple.security.get-task-allow`  ")
                    }
                    
                    if execEvent.target.skip_lv {
                        Image(systemName: "lock.open.trianglebadge.exclamationmark").padding(.leading)
                        Text("`com.apple.security.cs.disable-library-validation`  ")
                    }
                }.background(Rectangle().fill(Color.orange.opacity(0.3)))
            }
        }
    }
}
