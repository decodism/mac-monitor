//
//  EventStreamControl.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 4/7/23.
//

import Foundation
import OSLog
import AppKit


// @discussion notes are from Endpoint Security documentation
@objc public enum NewClientResult: Int {
    // @note The caller has reached the maximum number of allowed simultaneously connected clients.
    case tooManyClients
    // @note The caller is not properly entitled to connect.
    case notEntitled
    // @note The caller lacks Transparency, Consent, and Control (TCC) approval from the user.
    case notPermitted
    // @note The caller is not running as root.
    case notPrivileged
    // @note Communication with the ES subsystem failed, or other error condition.
    case internalSubsystem
    // @note One or more invalid arguments were provided.
    case invalidArgument
    case waiting
    case success
}


// MARK: - ES client operations
func validateClient(result: es_new_client_result_t) -> NewClientResult {
    var tempConnResult: NewClientResult = .waiting
    switch result {
    case ES_NEW_CLIENT_RESULT_ERR_TOO_MANY_CLIENTS:
        os_log(OSLogType.error, "There are too many Endpoint Security clients!")
        tempConnResult = .tooManyClients
        return tempConnResult
    case ES_NEW_CLIENT_RESULT_ERR_NOT_ENTITLED:
        os_log(OSLogType.error, "Failed to create new Endpoint Security client! The endpoint security entitlement is required.")
        tempConnResult = .notEntitled
        return tempConnResult
    case ES_NEW_CLIENT_RESULT_ERR_NOT_PERMITTED:
        os_log(OSLogType.error, "Lacking TCC permissions!")
        tempConnResult = .notPermitted
        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!)
        return tempConnResult
    case ES_NEW_CLIENT_RESULT_ERR_NOT_PRIVILEGED:
        os_log(OSLogType.error, "Caller is not running as root!")
        print("Caller is not running as root!")
        tempConnResult = .notPrivileged
        return tempConnResult
    case ES_NEW_CLIENT_RESULT_ERR_INTERNAL:
        os_log(OSLogType.error, "Error communicating with Endpoint Security!")
        tempConnResult = .internalSubsystem
        return tempConnResult
    case ES_NEW_CLIENT_RESULT_ERR_INVALID_ARGUMENT:
        os_log(OSLogType.error, "Incorrect arguments creating a new Endpoint Security client!")
        print("Incorrect arguments creating a new ES client!")
        tempConnResult = .invalidArgument
        return tempConnResult
    case ES_NEW_CLIENT_RESULT_SUCCESS:
        os_log(OSLogType.error, "We successfully created a new Endpoint Security client!")
        tempConnResult = .success
        return tempConnResult
    default:
        os_log(OSLogType.error, "An unknown error occured while creating the Endpoint Security client!")
        return tempConnResult
    }
}


extension EndpointSecurityManager {
    // @discussion this function is used when "dropping" platform binaries.
    public func isEventCritical(message: Message) -> Bool {
        switch message.event {
        case .exec,
             .fork,
             .exit,
             .mmap,
             .create,
             .open,
             .close,
             .write,
             .unlink,
             .rename,
             .proc_suspend_resume,
             .get_task,
             .iokit_open,
             .dup,
             .deleteextattr,
             .setextattr,
             .signal,
             .xpc_connect:
            return false
        default:
            return true
        }
    }
}
