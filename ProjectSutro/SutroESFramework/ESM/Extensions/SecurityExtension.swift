//
//  SecurityExtension.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/7/23.
//

import Foundation
import SystemExtensions
import OSLog


// MARK: - System Extension install / uninstall
/// Extension of the ESM which enables System Extension functionality
///
/// **Functionality Covers:**
///   - Updating the Security Extension
///   - Activating the Security Extension
///   - Deactivating the Security Extension
///
extension EndpointSecurityManager {
    // MARK: - Agent Context
    /// Activate the Security Extension (Mac Monitor agent context)
    public func activateSystemExtension() {
        os_log("🥁 Installing the Mac Monitor Endpoint Security System Extension")
        let activationRequest = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: "com.swiftlydetecting.agent.securityextension", queue: .main)
        activationRequest.delegate = self
        OSSystemExtensionManager.shared.submitRequest(activationRequest)
    }
    
    /// Deactivate the Security Extension (Mac Monitor agent context)
    public func uninstallSystemExtension() {
        os_log("🛑 Requesting Security Extension deactivation")
        let deactivationRequest = OSSystemExtensionRequest.deactivationRequest(forExtensionWithIdentifier: "com.swiftlydetecting.agent.securityextension", queue: .main)
        deactivationRequest.delegate = self
        OSSystemExtensionManager.shared.submitRequest(deactivationRequest)
        os_log("Security Extension deactivated!")
        self.seIsInstalled = false
    }
    
    
    // MARK: - Sensor Context
    ///  Update the System Extension (Security Extension context)
    public func request(_ request: OSSystemExtensionRequest, actionForReplacingExtension existing: OSSystemExtensionProperties, withExtension ext: OSSystemExtensionProperties) -> OSSystemExtensionRequest.ReplacementAction {
        os_log("🔄 Updating the Mac Monitor security extension!")
        self.seIsInstalled = true
        return .replace
    }
    
    /// Successful activation of the System Extension (Security Extension context)
    public func request(_: OSSystemExtensionRequest, didFinishWithResult result: OSSystemExtensionRequest.Result) {
        if result == .completed {
            os_log("🥳 Mac Monitor Security Extension has been successfully installed!")
            self.seIsInstalled = true
        } else {
            self.seIsInstalled = false
        }
        kickoffXPCCommunication()
    }
    
    /// Unsuccessful activation of the System Extension (Security Extension context)
    ///
    /// This is likely because the app is not in `/Applications`.
    ///
    public func request(_: OSSystemExtensionRequest, didFailWithError error: Error) {
        os_log(OSLogType.error, "☠️ Please ensure the app is in `/Applications/`!")
        self.seIsInstalled = false
    }
    
    /// Waiting for the user to enable Fulll Disk Access (Security Extension context)
    public func requestNeedsUserApproval(_: OSSystemExtensionRequest) {
        os_log(OSLogType.error, "⏳ System Extension needs user approval in System Settings along with Full Disk Access.")
        self.seIsInstalled = false
    }
}
