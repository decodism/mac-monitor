//
//  TerminationDelegate.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 6/7/23.
//


import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    override init() {
        super.init()
        let userDefaults = UserDefaults.standard
        let defaultValues = [
            "lifecycleWarnBeforeQuit" : true,
            "lifecycleWarnBeforeClear" : true
        ]
        userDefaults.register(defaults: defaultValues)
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        if UserDefaults.standard.bool(forKey: "lifecycleWarnBeforeQuit") && !UserDefaults.standard.bool(forKey: "lifecycleQuitInternal") {
            let alert = NSAlert()
            alert.messageText = "Quit Mac Monitor?"
            alert.informativeText = "Please save your work. Quitting will clear any system trace."
            alert.addButton(withTitle: "Confirm App Quit")
            alert.addButton(withTitle: "Cancel")
            alert.showsSuppressionButton = true
            let response = alert.runModal()

            if let suppressionButton = alert.suppressionButton,
               suppressionButton.state == .on {
                UserDefaults.standard.set(false, forKey: "lifecycleWarnBeforeQuit")
            }

            return response == .alertFirstButtonReturn ? .terminateNow : .terminateCancel
        } else {
            return .terminateNow
        }
    }
}
