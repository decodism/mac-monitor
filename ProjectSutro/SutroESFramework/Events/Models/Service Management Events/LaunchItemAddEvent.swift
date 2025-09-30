//
//  LaunchItemAddEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 1/13/23.
//

import Foundation
import EndpointSecurity


// MARK: - Background Task Management (BTM) Launch Item Add event model https://developer.apple.com/documentation/endpointsecurity/3228936-es_events_t/4042928-btm_launch_item_add
public struct LaunchItemAddEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    public var file_path, file_name, plist_contents, type: String
//    public var uid_human: String
    public var is_legacy, is_managed: Bool
//    public var uid: Int64
    
    
    // Basic process information for the app
    public var app_process_path: String = ""
    public var app_process_signing_id: String = ""
    public var app_process_team_id: String = ""
    
    // Basic process information for the instigator
    public var instigating_process_path: String = ""
    public var instigating_process_signing_id: String = ""
    public var instigating_process_team_id: String = ""
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(file_path)
        hasher.combine(id)
    }
    
    public static func == (lhs: LaunchItemAddEvent, rhs: LaunchItemAddEvent) -> Bool {
        if lhs.file_path == rhs.file_path && lhs.id == rhs.id {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let lauchItemAddEvent: UnsafeMutablePointer<es_event_btm_launch_item_add_t> = rawMessage.pointee.event.btm_launch_item_add
        
        // MARK: BTM Launch Item properties
        self.file_path = String(String(cString: lauchItemAddEvent.pointee.item.pointee.item_url.data).trimmingPrefix("file://").replacing("%20", with: " "))
        self.file_name = URL(string: String(cString: lauchItemAddEvent.pointee.item.pointee.item_url.data))!.lastPathComponent
        
        // @note legacy plist
        self.is_legacy = lauchItemAddEvent.pointee.item.pointee.legacy
        // @note this BTM item is managed by MDM
        self.is_managed = lauchItemAddEvent.pointee.item.pointee.managed
        
        // MARK: App information
        if lauchItemAddEvent.pointee.app != nil {
            // Signing ID
            if lauchItemAddEvent.pointee.app!.pointee.signing_id.length > 0 {
                self.app_process_path = String(cString: lauchItemAddEvent.pointee.app!.pointee.signing_id.data)
            }
            
            // Team ID
            if lauchItemAddEvent.pointee.app!.pointee.team_id.length > 0 {
                self.app_process_team_id = String(cString: lauchItemAddEvent.pointee.app!.pointee.team_id.data)
            }
        }
        
        // MARK: Instigator information
        if lauchItemAddEvent.pointee.instigator != nil {
            // Signing ID
            if lauchItemAddEvent.pointee.instigator!.pointee.signing_id.length > 0 {
                self.app_process_signing_id = String(cString: lauchItemAddEvent.pointee.instigator!.pointee.signing_id.data)
            }
            
            // Team ID
            if lauchItemAddEvent.pointee.instigator!.pointee.team_id.length > 0 {
                self.app_process_team_id = String(cString: lauchItemAddEvent.pointee.instigator!.pointee.team_id.data)
            }
        }
        
        switch lauchItemAddEvent.pointee.item.pointee.item_type {
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

        // @discussion we'll attempt to pull the `plist` for this BTM item if it's an: agent or daemon (legacy) and... we can find it...
        if self.file_name.hasSuffix(".plist") && lauchItemAddEvent.pointee.item.pointee.item_type == ES_BTM_ITEM_TYPE_AGENT || lauchItemAddEvent.pointee.item.pointee.item_type == ES_BTM_ITEM_TYPE_DAEMON {
            self.plist_contents = ProcessHelpers.getPropertyListContents(at: self.file_path) ?? ""
        } else {
            self.plist_contents = ""
        }
        
    }
}
