//
//  UpdateEngine.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 8/5/25.
//

import Foundation
import OSLog

// MARK: - Update Details Data Structure
/// A structure to hold details about an available application update.
/// This is sent from the System Extension to the main app via XPC.
public struct UpdateDetails: Codable, Identifiable {
    public var id: String { version }
    public let version: String
    public let downloadURL: URL
    public let releaseNotes: String
    public let releaseDate: String
    
    public init(version: String, downloadURL: URL, releaseNotes: String, releaseDate: String) {
        self.version = version
        self.downloadURL = downloadURL
        self.releaseNotes = releaseNotes
        self.releaseDate = releaseDate
    }
}


extension EndpointSecurityManager {
    // MARK: Step #2 in checking for updates
    /// Initiates an asynchronous check for updates.
    /// - Parameter completion: A closure that will be called on the main thread with the result.
    ///                       It receives an optional `UpdateDetails` object or `nil` if no update is found or an error occurs.
    public func checkForUpdates(completion: @escaping (UpdateDetails?) -> Void) {
        RCXPCConnection.rcXPCConnection.checkForUpdates(epDelegate: self) { updateDetails in
            DispatchQueue.main.async {
                completion(updateDetails)
            }
        } 
    }
    
    // MARK: Step #2 in installing updates
    public func installUpdate(from pkgURL: URL, completion: @escaping (Bool) -> Void) {
        RCXPCConnection.rcXPCConnection.installUpdate(from: pkgURL, epDelegate: self, completion: completion)
    }

}
