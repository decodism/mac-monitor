//
//  ESEventType+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/2/25.
//
//

import Foundation
import CoreData

@objc(ESEventType)
public class ESEventType: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        
        /// Process events
        case exec
        case fork
        case exit
        case signal
        case proc_suspend_resume
        
        /// Interporcess events
        case remote_thread_create
        case trace
        
        /// Code signing events
        case cs_invalidated
        
        /// Memory mapping events
        case mmap
        
        /// File system events
        case create
        case unlink
        case rename
        case open
        case write
        case close
        case dup
        
        /// Symbolic link events
        case link
        
        /// File metadata events
        case setextattr
        case deleteextattr
        case setmode
        
        /// Pseudoterminal events
        case pty_grant
        
        /// File system mounting events
        case mount
        
        /// Login events
        case login_login
        case lw_session_login
        case lw_session_unlock
        
        /// OpenSSH events
        case openssh_login
        case openssh_logout
        
        /// Kernel events
        case iokit_open
        
        /// Security Authorization events
        case authorization_petition
        case authorization_judgement
        
        /// Task port events
        case get_task
        case proc_check
        
        /// MDM events
        case profile_add
        
        /// Service management events
        case btm_launch_item_add
        case btm_launch_item_remove
        
        /// XProtect events
        case xp_malware_detected
        case xp_malware_remediated
        
        /// Directory events
        case od_create_user
        case od_modify_password
        case od_group_add
        case od_group_remove
        case od_create_group
        case od_attribute_value_add
        
        /// XPC events
        case xpc_connect
        
        /// Socket events
        case uipc_connect
        
        /// TCC events
        case tcc_modify
        
        /// Gatekeeper events
        case gatekeeper_user_override
    }
    
    // MARK: - Custom Initializer for ESEventType
    convenience init(from message: Message) {
        self.init()
        self.id = UUID()

        switch message.event {
        // MARK: Process events
        case .exec(_):
            self.exec = ESProcessExecEvent(from: message)
        case .fork(_):
            self.fork = ESProcessForkEvent(from: message)
        case .exit(_):
            self.exit = ESProcessExitEvent(from: message)
        case .signal(_):
            self.signal = ESProcessSignalEvent(from: message)
        case .proc_suspend_resume(_):
            self.proc_suspend_resume = ESProcessSocketEvent(from: message)
        case .proc_check(_):
            self.proc_check = ESProcessCheckEvent(from: message)
            
        // MARK: Interprocess events
        case .trace(_):
            self.trace = ESProcessTraceEvent(from: message)
        
        case .remote_thread_create(_):
            self.remote_thread_create = ESRemoteThreadCreateEvent(from: message)
            
        // MARK: Code Signing events
        case .cs_invalidated(_):
            self.cs_invalidated = ESCodeSignatureInvalidatedEvent(from: message)

        // MARK: Memory mapping events
        case .mmap(_):
            self.mmap = ESMMapEvent(from: message)
            
        // MARK: File System events
        case .create(_):
            self.create = ESFileCreateEvent(from: message)
        case .unlink(_):
            self.unlink = ESFileDeleteEvent(from: message)
        case .rename(_):
            self.rename = ESFileRenameEvent(from: message)
        case .open(_):
            self.open = ESFileOpenEvent(from: message)
        case .write(_):
            self.write = ESFileWriteEvent(from: message)
        case .close(_):
            self.close = ESFileCloseEvent(from: message)
        case .dup(_):
            self.dup = ESFDDuplicateEvent(from: message)
            
        // MARK: Symbolic Link events
        case .link(_):
            self.link = ESLinkEvent(from: message)
        
        // MARK: File Metadata events
        case .setextattr(_):
            self.setextattr = ESXattrSetEvent(from: message)
        case .deleteextattr(_):
            self.deleteextattr = ESXattrDeleteEvent(from: message)
        case .setmode(_):
            self.setmode = ESSetModeEvent(from: message)
        
        // MARK: File Metadata events
        case .pty_grant(_):
            self.pty_grant = ESPTYGrantEvent(from: message)

        // MARK: File System Mounting events
        case .mount(_):
            self.mount = ESMountEvent(from: message)

        // MARK: Login events
        case .login_login(_):
            self.login_login = ESLoginLoginEvent(from: message)
        case .lw_session_login(_):
            self.lw_session_login = ESLWLoginEvent(from: message)
        case .lw_session_unlock(_):
            self.lw_session_unlock = ESLWUnlockEvent(from: message)
            
        // MARK: OpenSSH events
        case .openssh_login(_):
            self.openssh_login = ESOpenSSHLoginEvent(from: message)
        case .openssh_logout(_):
            self.openssh_logout = ESOpenSSHLogoutEvent(from: message)

        // MARK: Kernel events
        case .iokit_open(_):
            self.iokit_open = ESIOKitOpenEvent(from: message)
        
        // MARK: Security Authorization events
        case .authorization_petition(_):
            self.authorization_petition = ESAuthorizationPetitionEvent(from: message)
        case .authorization_judgement(_):
            self.authorization_judgement = ESAuthorizationJudgementEvent(from: message)

        // MARK: Task Port events
        case .get_task(_):
            self.get_task = ESGetTaskEvent(from: message)
        
        // MARK: MDM events
        case .profile_add(_):
            self.profile_add = ESProfileAddEvent(from: message)

        // MARK: Service Management events
        case .btm_launch_item_add(_):
            self.btm_launch_item_add = ESLaunchItemAddEvent(from: message)
        case .btm_launch_item_remove(_):
            self.btm_launch_item_remove = ESLaunchItemRemoveEvent(from: message)

        // MARK: XProtect events
        case .xp_malware_detected(_):
            self.xp_malware_detected = ESXProtectDetect(from: message)
        case .xp_malware_remediated(_):
            self.xp_malware_remediated = ESXProtectRemediate(from: message)

        // MARK: Directory events
        case .od_create_user(_):
            self.od_create_user = ESODCreateUserEvent(from: message)
        case .od_modify_password(_):
            self.od_modify_password = ESODModifyPasswordEvent(from: message)
        case .od_group_add(_):
            self.od_group_add = ESODGroupAddEvent(from: message)
        case .od_group_remove(_):
            self.od_group_remove = ESODGroupRemoveEvent(from: message)
        case .od_create_group(_):
            self.od_create_group = ESODCreateGroupEvent(from: message)
        case .od_attribute_value_add(_):
            self.od_attribute_value_add = ESODAttributeValueAddEvent(from: message)

        // MARK: XPC events
        case .xpc_connect(_):
            self.xpc_connect = ESXPCConnectEvent(from: message)
        
        // MARK: Socket events
        case .uipc_connect(_):
            self.uipc_connect = ESUIPCConnectEvent(from: message)
            
        // MARK: TCC events
        case .tcc_modify(_):
            self.tcc_modify = ESTCCModifyEvent(from: message)
        
        // MARK: Gatekeeper events
        case .gatekeeper_user_override(_):
            self.gatekeeper_user_override = ESGatekeeperUserOverrideEvent(from: message)

        default:
            break
        }
    }
    
    // MARK: - Custom Core Data initilizer for ESEventType
    convenience init(
        from message: Message,
        insertIntoManagedObjectContext context: NSManagedObjectContext!
    ) {
        let description = NSEntityDescription.entity(forEntityName: "ESEventType", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = UUID()
        
        switch message.event {
        // MARK: Process events
        case .exec(_):
            self.exec = ESProcessExecEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .fork(_):
            self.fork = ESProcessForkEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .exit(_):
            self.exit = ESProcessExitEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .signal(_):
            self.signal = ESProcessSignalEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .proc_suspend_resume(_):
            self.proc_suspend_resume = ESProcessSocketEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .proc_check(_):
            self.proc_check = ESProcessCheckEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
            
            
        // MARK: Interprocess events
        case .remote_thread_create(_):
            self.remote_thread_create = ESRemoteThreadCreateEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .trace(_):
            self.trace = ESProcessTraceEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
            
            
        // MARK: Code Signing events
        case .cs_invalidated(_):
            self.cs_invalidated = ESCodeSignatureInvalidatedEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        
        
            
        // MARK: Memory mapping events
        case .mmap(_):
            self.mmap = ESMMapEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
            
            
        // MARK: File System events
        case .create(_):
            self.create = ESFileCreateEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .rename(_):
            self.rename = ESFileRenameEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .open(_):
            self.open = ESFileOpenEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .write(_):
            self.write = ESFileWriteEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .close(_):
            self.close = ESFileCloseEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .unlink(_):
            self.unlink = ESFileDeleteEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .dup(_):
            self.dup = ESFDDuplicateEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
            
            
        // MARK: Symbolic Link events
        case .link(_):
            self.link = ESLinkEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )

            
        // MARK: File Metadata events
        case .setextattr(_):
            self.setextattr = ESXattrSetEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .deleteextattr(_):
            self.deleteextattr = ESXattrDeleteEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .setmode(_):
            self.setmode = ESSetModeEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        
        
        // MARK: Pseudoterminal Event
        case .pty_grant(_):
            self.pty_grant = ESPTYGrantEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )

            
        // MARK: File System Mounting events
        case .mount(_):
            self.mount = ESMountEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )

            
        // MARK: Login events
        case .login_login(_):
            self.login_login = ESLoginLoginEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .lw_session_login(_):
            self.lw_session_login = ESLWLoginEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .lw_session_unlock(_):
            self.lw_session_unlock = ESLWUnlockEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
            
            
        // MARK: OpenSSH events
        case .openssh_login(_):
            self.openssh_login = ESOpenSSHLoginEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .openssh_logout(_):
            self.openssh_logout = ESOpenSSHLogoutEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )

            
        // MARK: Kernel events
        case .iokit_open(_):
            self.iokit_open = ESIOKitOpenEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )

        
        // MARK: Security Authorization events
        case .authorization_petition(_):
            self.authorization_petition = ESAuthorizationPetitionEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .authorization_judgement(_):
            self.authorization_judgement = ESAuthorizationJudgementEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )

            
        // MARK: Task Port events
        case .get_task(_):
            self.get_task = ESGetTaskEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        
            
        // MARK: MDM events
        case .profile_add(_):
            self.profile_add = ESProfileAddEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )

            
        // MARK: Service Management events
        case .btm_launch_item_add(_):
            self.btm_launch_item_add = ESLaunchItemAddEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .btm_launch_item_remove(_):
            self.btm_launch_item_remove = ESLaunchItemRemoveEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )

            
        // MARK: XProtect events
        case .xp_malware_detected(_):
            self.xp_malware_detected = ESXProtectDetect(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .xp_malware_remediated(_):
            self.xp_malware_remediated = ESXProtectRemediate(
                from: message,
                insertIntoManagedObjectContext: context
            )

            
        // MARK: Directory events
        case .od_create_user(_):
            self.od_create_user = ESODCreateUserEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .od_modify_password(_):
            self.od_modify_password = ESODModifyPasswordEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .od_group_add(_):
            self.od_group_add = ESODGroupAddEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .od_group_remove(_):
            self.od_group_remove = ESODGroupRemoveEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .od_create_group(_):
            self.od_create_group = ESODCreateGroupEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
        case .od_attribute_value_add(_):
            self.od_attribute_value_add = ESODAttributeValueAddEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )

            
        // MARK: XPC events
        case .xpc_connect(_):
            self.xpc_connect = ESXPCConnectEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
         
        // MARK: Socket events
        case .uipc_connect(_):
            self.uipc_connect = ESUIPCConnectEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
            
        // MARK: TCC events
        case .tcc_modify(_):
            self.tcc_modify = ESTCCModifyEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
            
        // MARK: Gatekeeper events
        case .gatekeeper_user_override(_):
            self.gatekeeper_user_override = ESGatekeeperUserOverrideEvent(
                from: message,
                insertIntoManagedObjectContext: context
            )
            
        default:
            break
        }
        
        
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        
        // MARK: Process events
        try exec = container.decodeIfPresent(ESProcessExecEvent.self, forKey: .exec)
        try fork = container.decodeIfPresent(ESProcessForkEvent.self, forKey: .fork)
        try exit = container.decodeIfPresent(ESProcessExitEvent.self, forKey: .exit)
        try signal = container.decodeIfPresent(ESProcessSignalEvent.self, forKey: .signal)
        try proc_suspend_resume = container.decodeIfPresent(ESProcessSocketEvent.self, forKey: .proc_suspend_resume)
        try proc_check = container.decodeIfPresent(ESProcessCheckEvent.self, forKey: .proc_check)
        
        // MARK: Interprocess events
        try remote_thread_create = container.decodeIfPresent(ESRemoteThreadCreateEvent.self, forKey: .remote_thread_create)
        try trace = container.decodeIfPresent(ESProcessTraceEvent.self, forKey: .trace)

        // MARK: Code Signing events
        try cs_invalidated = container.decodeIfPresent(ESCodeSignatureInvalidatedEvent.self, forKey: .cs_invalidated)
        
        // MARK: Memory mapping events
        try mmap = container.decodeIfPresent(ESMMapEvent.self, forKey: .mmap)

        // MARK: File System events
        try create = container.decodeIfPresent(ESFileCreateEvent.self, forKey: .create)
        try unlink = container.decodeIfPresent(ESFileDeleteEvent.self, forKey: .unlink)
        try rename = container.decodeIfPresent(ESFileRenameEvent.self, forKey: .rename)
        try `open` = container.decodeIfPresent(ESFileOpenEvent.self, forKey: .open)
        try write = container.decodeIfPresent(ESFileWriteEvent.self, forKey: .write)
        try close = container.decodeIfPresent(ESFileCloseEvent.self, forKey: .close)
        try dup = container.decodeIfPresent(ESFDDuplicateEvent.self, forKey: .dup)
        
        // MARK: Symbolic Link events
        try link = container.decodeIfPresent(ESLinkEvent.self, forKey: .link)
        
        // MARK: File Metadata events
        try setextattr = container.decodeIfPresent(ESXattrSetEvent.self, forKey: .setextattr)
        try deleteextattr = container.decodeIfPresent(ESXattrDeleteEvent.self, forKey: .deleteextattr)
        try setmode = container.decodeIfPresent(ESSetModeEvent.self, forKey: .setmode)
        
        // MARK: Pseudoterminal event
        try pty_grant = container.decodeIfPresent(ESPTYGrantEvent.self, forKey: .pty_grant)
        
        // MARK: File System Mounting events
        try mount = container.decodeIfPresent(ESMountEvent.self, forKey: .mount)
        
        // MARK: Login events
        try login_login = container.decodeIfPresent(ESLoginLoginEvent.self, forKey: .login_login)
        try lw_session_login = container.decodeIfPresent(ESLWLoginEvent.self, forKey: .lw_session_login)
        try lw_session_unlock = container.decodeIfPresent(ESLWUnlockEvent.self, forKey: .lw_session_unlock)
        
        // MARK: OpenSSH events
        try openssh_login = container.decodeIfPresent(ESOpenSSHLoginEvent.self, forKey: .openssh_login)
        try openssh_logout = container.decodeIfPresent(ESOpenSSHLogoutEvent.self, forKey: .openssh_logout)

        // MARK: Kernel events
        try iokit_open = container.decodeIfPresent(ESIOKitOpenEvent.self, forKey: .iokit_open)

        
        // MARK: Security Authorization events
        try authorization_petition = container.decodeIfPresent(ESAuthorizationPetitionEvent.self, forKey: .authorization_petition)
        try authorization_judgement = container.decodeIfPresent(ESAuthorizationJudgementEvent.self, forKey: .authorization_judgement)

        // MARK: Task Port events
        try get_task = container.decodeIfPresent(ESGetTaskEvent.self, forKey: .get_task)
        
        // MARK: MDM events
        try profile_add = container.decodeIfPresent(ESProfileAddEvent.self, forKey: .profile_add)

        // MARK: Service Management events
        try btm_launch_item_add = container.decodeIfPresent(ESLaunchItemAddEvent.self, forKey: .btm_launch_item_add)
        try btm_launch_item_remove = container.decodeIfPresent(ESLaunchItemRemoveEvent.self, forKey: .btm_launch_item_remove)

        // MARK: XProtect events
        try xp_malware_detected = container.decodeIfPresent(ESXProtectDetect.self, forKey: .xp_malware_detected)
        try xp_malware_remediated = container.decodeIfPresent(ESXProtectRemediate.self, forKey: .xp_malware_remediated)
        
        // MARK: Directory events
        try od_create_user = container.decodeIfPresent(ESODCreateUserEvent.self, forKey: .od_create_user)
        try od_modify_password = container.decodeIfPresent(ESODModifyPasswordEvent.self, forKey: .od_modify_password)
        try od_group_add = container.decodeIfPresent(ESODGroupAddEvent.self, forKey: .od_group_add)
        try od_group_remove = container.decodeIfPresent(ESODGroupRemoveEvent.self, forKey: .od_group_remove)
        try od_create_group = container.decodeIfPresent(ESODCreateGroupEvent.self, forKey: .od_create_group)
        try od_attribute_value_add = container.decodeIfPresent(ESODAttributeValueAddEvent.self, forKey: .od_attribute_value_add)
        
        // MARK: XPC events
        try xpc_connect = container.decodeIfPresent(ESXPCConnectEvent.self, forKey: .xpc_connect)
        
        // MARK: Socket events
        try uipc_connect = container.decodeIfPresent(ESUIPCConnectEvent.self, forKey: .uipc_connect)
        
        // MARK: TCC events
        try tcc_modify = container.decodeIfPresent(ESTCCModifyEvent.self, forKey: .tcc_modify)
        
        // MARK: Gatekeeper events
        try gatekeeper_user_override = container.decodeIfPresent(ESGatekeeperUserOverrideEvent.self, forKey: .tcc_modify)
    }

}

// MARK: - Encodable conformance
extension ESEventType: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // MARK: Process events
        try container.encodeIfPresent(exec, forKey: .exec)
        try container.encodeIfPresent(fork, forKey: .fork)
        try container.encodeIfPresent(exit, forKey: .exit)
        try container.encodeIfPresent(signal, forKey: .signal)
        try container.encodeIfPresent(proc_suspend_resume, forKey: .proc_suspend_resume)
        try container.encodeIfPresent(proc_check, forKey: .proc_check)
        
        // MARK: Interprocess events
        try container.encodeIfPresent(trace, forKey: .trace)
        try container.encodeIfPresent(remote_thread_create, forKey: .remote_thread_create)
        
        // MARK: Code Signing events
        try container.encodeIfPresent(cs_invalidated, forKey: .cs_invalidated)

        // MARK: Memory mapping events
        try container.encodeIfPresent(mmap, forKey: .mmap)

        // MARK: File System events
        try container.encodeIfPresent(create, forKey: .create)
        try container.encodeIfPresent(unlink, forKey: .unlink)
        try container.encodeIfPresent(rename, forKey: .rename)
        try container.encodeIfPresent(open, forKey: .open)
        try container.encodeIfPresent(write, forKey: .write)
        try container.encodeIfPresent(close, forKey: .close)
        try container.encodeIfPresent(dup, forKey: .dup)
        
        // MARK: Symbolic Link events
        try container.encodeIfPresent(link, forKey: .link)

        // MARK: File Metadata events
        try container.encodeIfPresent(setextattr, forKey: .setextattr)
        try container.encodeIfPresent(deleteextattr, forKey: .deleteextattr)
        try container.encodeIfPresent(setmode, forKey: .setmode)
        
        // MARK: Pseudoterminal events
        try container.encodeIfPresent(pty_grant, forKey: .pty_grant)

        // MARK: File System Mounting events
        try container.encodeIfPresent(mount, forKey: .mount)

        // MARK: Login events
        try container.encodeIfPresent(login_login, forKey: .login_login)
        try container.encodeIfPresent(lw_session_login, forKey: .lw_session_login)
        try container.encodeIfPresent(lw_session_unlock, forKey: .lw_session_unlock)
        
        // MARK: OpenSSH events
        try container.encodeIfPresent(openssh_login, forKey: .openssh_login)
        try container.encodeIfPresent(openssh_logout, forKey: .openssh_logout)

        // MARK: Kernel events
        try container.encodeIfPresent(iokit_open, forKey: .iokit_open)
        
        // MARK: Security Authorization events
        try container.encodeIfPresent(authorization_petition, forKey: .authorization_petition)
        try container.encodeIfPresent(authorization_judgement, forKey: .authorization_judgement)

        // MARK: Task Port events
        try container.encodeIfPresent(get_task, forKey: .get_task)
        
        // MARK: MDM events
        try container.encodeIfPresent(profile_add, forKey: .profile_add)
        
        // MARK: Service Management events
        try container.encodeIfPresent(btm_launch_item_add, forKey: .btm_launch_item_add)
        try container.encodeIfPresent(btm_launch_item_remove, forKey: .btm_launch_item_remove)
        
        // MARK: XProtect events
        try container.encodeIfPresent(xp_malware_detected, forKey: .xp_malware_detected)
        try container.encodeIfPresent(xp_malware_remediated, forKey: .xp_malware_remediated)
        
        // MARK: Directory events
        try container.encodeIfPresent(od_create_user, forKey: .od_create_user)
        try container.encodeIfPresent(od_modify_password, forKey: .od_modify_password)
        try container.encodeIfPresent(od_group_add, forKey: .od_group_add)
        try container.encodeIfPresent(od_group_remove, forKey: .od_group_remove)
        try container.encodeIfPresent(od_create_group, forKey: .od_create_group)
        try container.encodeIfPresent(od_attribute_value_add, forKey: .od_attribute_value_add)
        
        // MARK: XPC events
        try container.encodeIfPresent(xpc_connect, forKey: .xpc_connect)
        
        // MARK: Socket events
        try container.encodeIfPresent(uipc_connect, forKey: .uipc_connect)
        
        // MARK: TCC events
        try container.encodeIfPresent(tcc_modify, forKey: .tcc_modify)
        
        // MARK: Gatekeeper events
        try container.encodeIfPresent(gatekeeper_user_override, forKey: .gatekeeper_user_override)
    }
}
