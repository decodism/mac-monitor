//
//  Process.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 3/9/25.
//

import Foundation
import OSLog


public enum CodeSigningType: String, Codable {
    case platform = "PLATFORM"
    case developerId = "DEVELOPER_ID"
    case appStore = "APP_STORE"
    case adhoc = "ADHOC"
    case unsigned = "UNSIGNED"
    case unknown = "UNKNOWN"
}

public enum FileQuarantineType: String, Codable {
    case optIn = "OPT_IN"
    case forced = "FORCED"
    case disabled = "DISABLED"
}


/// Models an `es_process_t`
/// Ensure Process conforms to Codable and Equatable
public struct Process: Identifiable, Codable, Hashable {
    public var id = UUID()
    
    /// Time
    public var start_time: TimeVal

    /// PIDs
    public var pid, ppid, original_ppid: Int32
    public var group_id, session_id: Int32
    
    /// Code signing
    public var codesigning_flags: Int64
    public var cdhash, signing_id, team_id: String?
    public var cs_validation_category: Int32?
    
    /// Audit tokens
    public var audit_token, responsible_audit_token, parent_audit_token: AuditToken?
    public var audit_token_string, responsible_audit_token_string, parent_audit_token_string: String
    
    /// Executable
    public var executable: File?
    public var is_platform_binary, is_es_client: Bool
    
    /// TTY
    public var tty: File?
    
    /// Mac Monitor enrichment
    public var euid, ruid: Int?
    public var euid_human, ruid_human: String?
    public var codesigning_type: CodeSigningType
    public var file_quarantine_type: FileQuarantineType
    // public var command_line: String?
    // Inc. dangerous entitlements
    public var is_adhoc_signed, get_task_allow, allow_jit, rootless, skip_lv: Bool
    public var cs_validation_category_string: String?
    
    public init(from process: es_process_t, version: Int, isExecMessage: Bool = false) {
        self.start_time = TimeVal(from: process.start_time)

        self.audit_token = AuditToken(from: process.audit_token)
        self.audit_token_string = process.audit_token.toString()
        self.parent_audit_token = AuditToken(from: process.parent_audit_token)
        self.parent_audit_token_string = process.parent_audit_token.toString()
        self.responsible_audit_token = AuditToken(
            from: process.responsible_audit_token
        )
        self.responsible_audit_token_string = process.responsible_audit_token.toString()

        self.pid = process.audit_token.pid()
        self.ppid = process.ppid
        self.original_ppid = process.original_ppid
        self.group_id = process.group_id
        self.session_id = process.session_id
        
        self.codesigning_flags = Int64(process.codesigning_flags)
        // macOS 26 support
        if version >= 10 {
            self.cs_validation_category = Int32(process.cs_validation_category.rawValue)
            switch(process.cs_validation_category) {
            case ES_CS_VALIDATION_CATEGORY_NONE:
                self.cs_validation_category_string = "ES_CS_VALIDATION_CATEGORY_NONE"
            case ES_CS_VALIDATION_CATEGORY_OOPJIT:
                self.cs_validation_category_string = "ES_CS_VALIDATION_CATEGORY_OOPJIT"
            case ES_CS_VALIDATION_CATEGORY_INVALID:
                self.cs_validation_category_string = "ES_CS_VALIDATION_CATEGORY_INVALID"
            case ES_CS_VALIDATION_CATEGORY_ROSETTA:
                self.cs_validation_category_string = "ES_CS_VALIDATION_CATEGORY_ROSETTA"
            case ES_CS_VALIDATION_CATEGORY_PLATFORM:
                self.cs_validation_category_string = "ES_CS_VALIDATION_CATEGORY_PLATFORM"
            case ES_CS_VALIDATION_CATEGORY_ENTERPRISE:
                self.cs_validation_category_string = "ES_CS_VALIDATION_CATEGORY_ENTERPRISE"
            case ES_CS_VALIDATION_CATEGORY_TESTFLIGHT:
                self.cs_validation_category_string = "ES_CS_VALIDATION_CATEGORY_TESTFLIGHT"
            case ES_CS_VALIDATION_CATEGORY_DEVELOPMENT:
                self.cs_validation_category_string = "ES_CS_VALIDATION_CATEGORY_TESTFLIGHT"
            case ES_CS_VALIDATION_CATEGORY_APP_STORE:
                self.cs_validation_category_string = "ES_CS_VALIDATION_CATEGORY_APP_STORE"
            case ES_CS_VALIDATION_CATEGORY_DEVELOPER_ID:
                self.cs_validation_category_string = "ES_CS_VALIDATION_CATEGORY_DEVELOPER_ID"
            case ES_CS_VALIDATION_CATEGORY_LOCAL_SIGNING:
                self.cs_validation_category_string = "ES_CS_VALIDATION_CATEGORY_LOCAL_SIGNING"
            default:
                self.cs_validation_category_string = "UNKNOWN"
            }
        }
        
        if process.signing_id.length > 0 {
            self.signing_id = String(cString: process.signing_id.data)
        }
        if process.team_id.length > 0 {
            self.team_id = String(cString: process.team_id.data)
        }
        
        self.executable = File(from: process.executable.pointee)
        
        self.is_platform_binary = process.is_platform_binary
        self.is_es_client = process.is_es_client
        self.codesigning_type = ProcessHelpers.codeSigningType(for: process)
        
        // Code Signing Blobs: Exposes Kernel/kern/cs_blobs.h header file
        self.is_adhoc_signed = (Int(process.codesigning_flags) & Int(CS_ADHOC)) == Int(CS_ADHOC)
        self.get_task_allow = (Int(process.codesigning_flags) & Int(CS_GET_TASK_ALLOW)) == Int(CS_GET_TASK_ALLOW)
        //` com.apple.security.cs.allow-jit`
        self.allow_jit = (Int(process.codesigning_flags) & Int(CS_EXECSEG_JIT)) == Int(CS_EXECSEG_JIT)
        // `com.apple.rootless.restricted-nvram-variables.heritable entitlement`
        self.rootless = (Int(process.codesigning_flags) & Int(CS_NVRAM_UNRESTRICTED)) == Int(CS_NVRAM_UNRESTRICTED)
        // Skip library validation
        self.skip_lv = (Int(process.codesigning_flags) & Int(CS_EXECSEG_SKIP_LV)) == Int(CS_EXECSEG_SKIP_LV)

        if let ttyPointer = process.tty {
            self.tty = File(from: ttyPointer.pointee)
        }
        
        // MARK: User identification
        let ruid = audit_token_to_ruid(process.audit_token)
        let euid = audit_token_to_euid(process.audit_token)

        self.ruid = Int(ruid)
        self.euid = Int(euid)

        if let rpw = getpwuid(ruid) {
            self.ruid_human = String(cString: rpw.pointee.pw_name)
        }
        if let epw = getpwuid(euid) {
            self.euid_human = String(cString: epw.pointee.pw_name)
        }
        
        // MARK: File Quarantine-aware
        if let exe = self.executable {
            self.file_quarantine_type = ProcessHelpers
                .isQuarantineEnabled(forExecutableAt: exe.path, signingId: self.signing_id)
        } else {
            self.file_quarantine_type = .disabled
        }
        
        self.cdhash = cdhashToString(cdhash: process.cdhash)
    }
}
