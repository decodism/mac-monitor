//
//  ProcessLineage.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 9/17/25.
//

import Foundation
import SutroESFramework


/// Resolves and caches process lineage relationships for efficient filtering of Endpoint Security events.
///
/// This resolver builds an in-memory graph of process relationships from ES events, enabling
/// fast lookups of process trees. It tracks parent-child relationships through exec and fork events,
/// handling the nuance that exec events with the same PID represent process replacement rather than
/// new child processes.
///
/// ## Performance Characteristics
/// - Initialization: O(n) where n is the number of events
/// - Lineage computation: O(m) where m is the size of the resulting tree
/// - Filtering checks: O(1) after pre-computing lineage sets
///
/// ## Implementation Notes
/// - Exec events with matching PIDs are treated as process replacement, inheriting the parent
/// - Fork events create true parent-child relationships
/// - Cycle detection prevents infinite loops in malformed process trees
/// - Designed for single-use per filtering operation; instantiate fresh for each filter pass
public final class ProcessLineageResolver {
    private struct ProcessNode {
        let parentAuditToken: String
        let executablePath: String
    }
    
    private var tokenToNodeCache: [String: ProcessNode] = [:]
    private var childrenCache: [String: Set<String>] = [:] // parent -> children
    
    public init(events: [ESMessage]) {
        for event in events {
            addToCache(
                token: event.process.audit_token_string,
                parent: event.process.parent_audit_token_string,
                path: event.process.executable?.path
            )
            
            if let execEvent = event.event.exec,
               let targetPath = execEvent.target.executable?.path {
                let targetToken = execEvent.target.audit_token_string
                let isSamePidExec = (execEvent.target.audit_token?.pid == event.process.audit_token?.pid)
                let parentToken = isSamePidExec ?
                    event.process.parent_audit_token_string :
                    event.process.audit_token_string
                
                addToCache(token: targetToken, parent: parentToken, path: targetPath)
            }
            
            if let forkEvent = event.event.fork,
               let childPath = forkEvent.child.executable?.path {
                addToCache(
                    token: forkEvent.child.audit_token_string,
                    parent: event.process.audit_token_string,
                    path: childPath
                )
            }
        }
    }
    
    private func addToCache(token: String, parent: String, path: String?) {
        guard let path = path else { return }
        
        if tokenToNodeCache[token] == nil {
            tokenToNodeCache[token] = ProcessNode(
                parentAuditToken: parent,
                executablePath: path
            )
            childrenCache[parent, default: []].insert(token)
        }
    }
    
    /// Pre-compute tokens in the lineage tree of a path
    /// - Parameters:
    ///   - includedPath: The executable path to match
    ///   - includeAncestors: If true, includes parent processes (default: true)
    /// - Returns: Set of audit token strings that match the lineage criteria
    public func computeLineageSet(includedPath: String, includeAncestors: Bool = true) -> Set<String> {
        var result = Set<String>()
        
        // Find all direct matches
        let matchingTokens = tokenToNodeCache.filter { $0.value.executablePath == includedPath }.map { $0.key }
        
        for token in matchingTokens {
            result.insert(token)
            
            // Add all ancestors if requested
            if includeAncestors {
                var current = token
                var visited = Set<String>()
                while let node = tokenToNodeCache[current], !visited.contains(current) {
                    result.insert(current)
                    visited.insert(current)
                    current = node.parentAuditToken
                }
            }
            
            // Always add descendants
            addDescendants(of: token, to: &result)
        }
        
        return result
    }
    
    private func addDescendants(of token: String, to result: inout Set<String>) {
        guard let children = childrenCache[token] else { return }
        
        for child in children {
            if !result.contains(child) {
                result.insert(child)
                addDescendants(of: child, to: &result)
            }
        }
    }
}
