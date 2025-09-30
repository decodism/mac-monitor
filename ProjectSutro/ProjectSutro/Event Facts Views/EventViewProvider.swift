//
//  EventViewProvider.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 4/5/25.
//

import Foundation
import SwiftUI
import SutroESFramework


struct EventSpecificViewsProvider {
    let labelView: AnyView
    let metadataView: AnyView

    /// Initializes the provider by switching on the message type
    /// to determine the appropriate views.
    ///
    /// - Parameters:
    ///   - message: The ESMessage containing the event data.
    ///   - systemExtensionManager: The shared EndpointSecurityManager instance.
    ///   - allFilters: Binding to the filters state (passed if needed by metadata views).
    init(message: ESMessage, systemExtensionManager: EndpointSecurityManager, allFilters: Binding<Filters>) {
        switch message {
        // MARK: - Process events
        case _ where message.event.exec != nil:
            self.labelView = AnyView(ExecEventLabelView(message: message))
            self.metadataView = AnyView(SystemTargetExecProcMetadataView(selectedMessage: message))

        case _ where message.event.fork != nil:
            self.labelView = AnyView(ForkEventLabelView(message: message))
            self.metadataView = AnyView(SystemForkProcMetadataView(selectedMessage: message))
        
        case _ where message.event.exit != nil:
            self.labelView = AnyView(ExitEventLabelView(message: message))
            self.metadataView = AnyView(SystemProcExitMetadataView(esSystemEvent: message))

        case _ where message.event.signal != nil:
            self.labelView = AnyView(ProcessSignalEventLabelView(message: message))
            self.metadataView = AnyView(SystemProcessSignalMetadataView(esSystemEvent: message))
        
        case _ where message.event.proc_suspend_resume != nil:
            self.labelView = AnyView(ProcessSocketEventLabelView(message: message))
            self.metadataView = AnyView(SystemProcessSocketMetadataView(esSystemEvent: message))
            
        case _ where message.event.proc_check != nil:
            self.labelView = AnyView(ProcessCheckEventLabelView(message: message))
            self.metadataView = AnyView(SystemProcessCheckMetadataView(esSystemEvent: message))
            
        
        // MARK: - Interprocess events
        case _ where message.event.remote_thread_create != nil:
            self.labelView = AnyView(RemoteThreadCreateEventLabelView(message: message))
            self.metadataView = AnyView(SystemRemoteThreadCreateMetadataView(esSystemEvent: message))
        
        case _ where message.event.trace != nil:
            self.labelView = AnyView(ProcessTraceEventLabelView(message: message))
            self.metadataView = AnyView(SystemProcessTraceMetadataView(esSystemEvent: message))
            
            
        // MARK: - Code Signing events
        case _ where message.event.cs_invalidated != nil:
            self.labelView = AnyView(CodeSignatureInvalidatedEventLabelView(message: message))
            self.metadataView = AnyView(SystemCodeSigningInvalidatedMetadataView(esSystemEvent: message))
            
            
        // MARK: - Memory mapping events
        case _ where message.event.mmap != nil:
            self.labelView = AnyView(MMAPEventLabelView(message: message))
            self.metadataView = AnyView(SystemMMAPMetadataView(esSystemEvent: message))
            
            
        // MARK: - File System events
        case _ where message.event.create != nil:
             self.labelView = AnyView(FileCreateEventLabelView(message: message))
             self.metadataView = AnyView(
                SystemFileCreateMetadataView(esSystemEvent: message)
             )
        
        case _ where message.event.rename != nil:
            self.labelView = AnyView(FileRenameEventLabelView(message: message))
            self.metadataView = AnyView(SystemFileRenameMetadataView(esSystemEvent: message)
                .environmentObject(systemExtensionManager))
            
        case _ where message.event.open != nil:
             self.labelView = AnyView(FileOpenEventLabelView(message: message))
             self.metadataView = AnyView(SystemFileOpenMetadataView(esSystemEvent: message))
        
        case _ where message.event.write != nil:
            self.labelView = AnyView(FileWriteEventLabelView(message: message))
            self.metadataView = AnyView(SystemFileWriteMetadataView(esSystemEvent: message))
        
        case _ where message.event.close != nil:
            self.labelView = AnyView(FileCloseEventLabelView(message: message))
            self.metadataView = AnyView(SystemFileCloseMetadataView(esSystemEvent: message))

        case _ where message.event.unlink != nil:
            self.labelView = AnyView(FileDeleteEventLabelView(message: message))
            self.metadataView = AnyView(SystemUnlinkEventMetadataView(esSystemEvent: message))
            
        case _ where message.event.dup != nil:
            self.labelView = AnyView(FDDuplicateEventLabelView(message: message))
            self.metadataView = AnyView(SystemFDDuplicateMetadataView(esSystemEvent: message))
            
            
        // MARK: - Symbolic Link events
        case _ where message.event.link != nil:
            self.labelView = AnyView(FileLinkEventLabelView(message: message))
            self.metadataView = AnyView(SystemLinkEventMetadataView(esSystemEvent: message))
            
            
        // MARK: - File Metadata events
        case _ where message.event.setextattr != nil:
            self.labelView = AnyView(SetXattrEventLabelView(message: message))
            self.metadataView = AnyView(SystemSetXattrMetadataView(esSystemEvent: message))
            
        case _ where message.event.deleteextattr != nil:
            self.labelView = AnyView(DeleteXattrEventLabelView(message: message))
            self.metadataView = AnyView(SystemDeleteXattrMetadataView(esSystemEvent: message))
            
            
        // MARK: - Service Management events
        case _ where message.event.btm_launch_item_add != nil:
            self.labelView = AnyView(BTMLaunchItemAddEventLabelView(message: message))
            self.metadataView = AnyView(SystemBTMAddMetadataView(esSystemEvent: message))

        case _ where message.event.btm_launch_item_remove != nil:
            self.labelView = AnyView(BTMLaunchItemRemoveEventLabelView(message: message))
            self.metadataView = AnyView(SystemBTMRemoveMetadataView(esSystemEvent: message))


        // MARK: OpenSSH events
        case _ where message.event.openssh_login != nil:
            self.labelView = AnyView(OpenSSHLoginEventLabelView(message: message))
            self.metadataView = AnyView(SystemOpenSSHLoginMetadataView(esSystemEvent: message))

        case _ where message.event.openssh_logout != nil:
            self.labelView = AnyView(OpenSSHLoginEventLabelView(message: message))
            self.metadataView = AnyView(SystemOpenSSHLogoutMetadataView(esSystemEvent: message))

            
        // MARK: - XProtect events
        case _ where message.event.xp_malware_detected != nil:
            self.labelView = AnyView(XProtectMalwareDetectedEventLabelView(message: message))
            self.metadataView = AnyView(SystemXProtectDetectMetadataView(esSystemEvent: message))

        case _ where message.event.xp_malware_remediated != nil:
            self.labelView = AnyView(XProtectMalwareRemediatedEventLabelView(message: message))
            self.metadataView = AnyView(SystemXProtectRemediateMetadataView(esSystemEvent: message))

            
        // MARK: - File System Mounting events
        case _ where message.event.mount != nil:
            self.labelView = AnyView(MountEventLabelView(message: message))
            self.metadataView = AnyView(SystemMountMetadataView(esSystemEvent: message))

            
        // MARK: Login events
        case _ where message.event.login_login != nil:
            self.labelView = AnyView(LoginLoginEventLabelView(message: message))
            self.metadataView = AnyView(SystemLoginLoginMetadataView(esSystemEvent: message))

        case _ where message.event.lw_session_login != nil:
            self.labelView = AnyView(LoginWindowLoginEventLabelView(message: message))
            self.metadataView = AnyView(SystemLWLoginMetadataView(esSystemEvent: message))

        case _ where message.event.lw_session_unlock != nil:
            self.labelView = AnyView(LoginWindowUnlockEventLabelView(message: message))
            self.metadataView = AnyView(SystemLWUnlockMetadataView(esSystemEvent: message))
            

        // MARK: Kernel events
        case _ where message.event.iokit_open != nil:
            self.labelView = AnyView(IOKitOpenEventLabelView(message: message))
            self.metadataView = AnyView(SystemIOKitOpenMetadataView(esSystemEvent: message))


        // MARK: - Task Port events
        case _ where message.event.get_task != nil:
            self.labelView = AnyView(GetTaskEventLabelView(message: message))
            self.metadataView = AnyView(SystemGetTaskMetadataView(esSystemEvent: message))

        
        // MARK: MDM events
        case _ where message.event.profile_add != nil:
             self.labelView = AnyView(ProfileAddEventLabelView(message: message))
             self.metadataView = AnyView(SystemProfileAddMetadataView(esSystemEvent: message))

            
        // MARK: - Security Authorization events
        case _ where message.event.authorization_judgement != nil:
            self.labelView = AnyView(OrangeEventLabelView(message: message))
            self.metadataView = AnyView(SystemAuthorizationJudgementMetadataView(esSystemEvent: message))
            
        case _ where message.event.authorization_petition != nil:
            self.labelView = AnyView(OrangeEventLabelView(message: message))
            self.metadataView = AnyView(SystemAuthorizationPetitionMetadataView(esSystemEvent: message))
            
            
        // MARK: - XPC events
        case _ where message.event.xpc_connect != nil:
            self.labelView = AnyView(
                IntelligentEventLabelView(message: message)
            )
            self.metadataView = AnyView(SystemXPCConnectMetadataView(esSystemEvent: message))
            
            
        // MARK: - Open Directory events
        case _ where message.event.od_create_user != nil:
             self.labelView = AnyView(OpenDirectoryCreateUserEventLabelView(message: message))
             self.metadataView = AnyView(SystemOpenDirectoryCreateUserMetadataView(esSystemEvent: message))

        case _ where message.event.od_modify_password != nil:
             self.labelView = AnyView(OpenDirectoryModifyPasswordEventLabelView(message: message))
             self.metadataView = AnyView(SystemOpenDirectoryModifyPasswordMetadataView(esSystemEvent: message))

        case _ where message.event.od_group_add != nil:
            self.labelView = AnyView(OrangeEventLabelView(message: message))
            self.metadataView = AnyView(SystemOpenDirectoryGroupAddMetadataView(esSystemEvent: message))

        case _ where message.event.od_group_remove != nil:
            self.labelView = AnyView(OrangeEventLabelView(message: message))
            self.metadataView = AnyView(SystemOpenDirectoryGroupRemoveMetadataView(esSystemEvent: message))

        case _ where message.event.od_create_group != nil:
            self.labelView = AnyView(OrangeEventLabelView(message: message))
            self.metadataView = AnyView(SystemOpenDirectoryCreateGroupMetadataView(esSystemEvent: message))

        case _ where message.event.od_attribute_value_add != nil:
            self.labelView = AnyView(OrangeEventLabelView(message: message))
            self.metadataView = AnyView(SystemOpenDirectoryAttrAddMetadataView(esSystemEvent: message))
        
            
        // MARK: - TCC events
        case _ where message.event.tcc_modify != nil:
            self.labelView = AnyView(
                IntelligentEventLabelView(message: message)
            )
            self.metadataView = AnyView(SystemTCCModifyMetadataView(message: message))
        
        // MARK: - Gatekeeper events
        case _ where message.event.gatekeeper_user_override != nil:
            self.labelView = AnyView(
                IntelligentEventLabelView(message: message, criticality: .medium)
            )
            self.metadataView = AnyView(SystemGatekeeperUserOverrideMetadataView(message: message))

        
        default:
            self.labelView = AnyView(EmptyView())
            self.metadataView = AnyView(EmptyView())
        }
    }
}
