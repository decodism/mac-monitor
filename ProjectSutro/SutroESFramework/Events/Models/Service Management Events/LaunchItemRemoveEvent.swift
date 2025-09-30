//
//  LaunchItemRemoveEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/13/23.
//

import Foundation
import EndpointSecurity
import OSLog
//import SwiftCSBlobs
import Compression
import Security
import CryptoKit


// MARK: - Background Task Management (BTM) Launch Item Remove event model https://developer.apple.com/documentation/endpointsecurity/3228936-es_events_t/4042929-btm_launch_item_remove
public struct LaunchItemRemoveEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    // Basic process information for the app
    public var app_process_path: String = ""
    public var app_process_signing_id: String = ""
    public var app_process_team_id: String = ""
    
    // Basic process information for the instigator
    public var instigating_process_path: String = ""
    public var instigating_process_signing_id: String = ""
    public var instigating_process_team_id: String = ""
    
    public var file_path: String
    public var file_name: String
    public var legacy: Bool
    public var type: String
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(file_path)
        hasher.combine(id)
    }
    
    public static func == (lhs: LaunchItemRemoveEvent, rhs: LaunchItemRemoveEvent) -> Bool {
        if lhs.file_path == rhs.file_path && lhs.id == rhs.id {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let launchItemRemoveEvent: UnsafeMutablePointer<es_event_btm_launch_item_remove_t> = rawMessage.pointee.event.btm_launch_item_remove
        
        // MARK: BTM Launch Item properties
        self.file_path = String(String(cString: launchItemRemoveEvent.pointee.item.pointee.item_url.data).trimmingPrefix("file://").replacing("%20", with: " "))
        self.file_name = URL(string: String(cString: launchItemRemoveEvent.pointee.item.pointee.item_url.data))!.lastPathComponent
        self.legacy = launchItemRemoveEvent.pointee.item.pointee.legacy
        
        // MARK: App information
        if launchItemRemoveEvent.pointee.app != nil {
            // Signing ID
            if launchItemRemoveEvent.pointee.app!.pointee.signing_id.length > 0 {
                self.app_process_path = String(cString: launchItemRemoveEvent.pointee.app!.pointee.signing_id.data)
            }
            
            // Team ID
            if launchItemRemoveEvent.pointee.app!.pointee.team_id.length > 0 {
                self.app_process_team_id = String(cString: launchItemRemoveEvent.pointee.app!.pointee.team_id.data)
            }
        }
        
        // MARK: Instigator information
        if launchItemRemoveEvent.pointee.instigator != nil {
            // Signing ID
            if launchItemRemoveEvent.pointee.instigator!.pointee.signing_id.length > 0 {
                self.app_process_signing_id = String(cString: launchItemRemoveEvent.pointee.instigator!.pointee.signing_id.data)
            }
            
            // Team ID
            if launchItemRemoveEvent.pointee.instigator!.pointee.team_id.length > 0 {
                self.app_process_team_id = String(cString: launchItemRemoveEvent.pointee.instigator!.pointee.team_id.data)
            }
        }
        
        switch launchItemRemoveEvent.pointee.item.pointee.item_type {
        case ES_BTM_ITEM_TYPE_APP:
            self.type = "App"
            break
        case ES_BTM_ITEM_TYPE_AGENT:
            self.type = "Agent"
            break
        case ES_BTM_ITEM_TYPE_DAEMON:
            self.type = "Daemon"
            break
        case ES_BTM_ITEM_TYPE_USER_ITEM:
            self.type = "User Item"
            break
        case ES_BTM_ITEM_TYPE_LOGIN_ITEM:
            self.type = "Login Item"
            break
        default:
            self.type = "Unknown"
        }
        
    }
}
