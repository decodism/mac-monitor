//
//  ProcessLineage.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 9/17/25.
//

import Foundation
import SutroESFramework


/// Resolve and check process lineage from a collection of ESMessage events.
///
/// Builds an in-memory cache of process information when filtering large numbers of events.
/// It is designed to be instantiated once per filtering operation.
/// It uses audit tokens to track parent-child relationships.
public final class ProcessLineageResolver {

    private struct ProcessNode {
        let parentAuditToken: String
        let executablePath: String
    }
    
    /// The cache mapping a process's audit token string to its corresponding ProcessNode.
    private var tokenToNodeCache: [String: ProcessNode] = [:]
    
    /// Initializes the resolver and builds the process cache from audit tokens.
    ///
    /// - Parameter events: An array of `ESMessage` objects from Core Data.
    public init(events: [ESMessage]) {
        for event in events {
            guard let executablePath = event.process.executable?.path else { continue }
            let auditToken = event.process.audit_token_string
            let parentAuditToken = event.process.parent_audit_token_string
            
            if tokenToNodeCache[auditToken] == nil {
                tokenToNodeCache[auditToken] = ProcessNode(
                    parentAuditToken: parentAuditToken,
                    executablePath: executablePath
                )
            }
        }
    }
    
    /// Walks up the process tree from the given event's process to check if any ancestor matches the specified executable path.
    ///
    /// - Parameters:
    ///   - event: The `ESMessage` event whose lineage should be checked.
    ///   - includedPath: The root executable path to check for in the process tree.
    /// - Returns: `true` if the event's process or any of its ancestors match the `includedPath`.
    public func lineageMatches(event: ESMessage, includedPath: String) -> Bool {
        if event.process.executable?.path == includedPath {
            return true
        }
        
        var currentToken = event.process.parent_audit_token_string
        var checkedTokens = Set<String>([event.process.audit_token_string])

        while let node = tokenToNodeCache[currentToken], !checkedTokens.contains(currentToken) {
            // Check if the current process in the tree matches the filter path.
            if node.executablePath == includedPath {
                return true
            }
            
            // Prevent further processing if we detect a cycle.
            guard node.parentAuditToken != currentToken else { break }
            
            checkedTokens.insert(currentToken)
            currentToken = node.parentAuditToken
        }
        
        return false
    }
}
