//
//  Process+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 3/9/25.
//
//

import Foundation
import CoreData

@objc(ESProcess)
public class ESProcess: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        
        /// Time
        case start_time
        
        /// PIDs
        case pid
        case ppid
        case original_ppid
        case group_id
        case session_id
        
        /// Audit tokens
        case audit_token
        case audit_token_string
        case parent_audit_token
        case parent_audit_token_string
        case responsible_audit_token
        case responsible_audit_token_string
        
        /// Codesigning
        case codesigning_flags
        case cdhash
        case signing_id
        case team_id
        case is_adhoc_signed
        case is_platform_binary
        case is_es_client
        case cs_validation_category // macOS 26
        case cs_validation_category_string // macOS 26
        
        /// Executable
        case executable
        
        /// @note Enrichment - File Quarantine and Codesigning
        case file_quarantine_type
        case codesigning_type
        
        /// TTY
        case tty
        
        /// @note Enrichment - User identification
        case euid
        case euid_human
        case ruid
        case ruid_human
        
        /// @note Enrichment - Command line
        // case command_line
    }
    
    // MARK: - Custom initilizer for ESProcess
    convenience init(from process: Process, version: Int) {
        self.init()
        self.id = process.id
        
        /// Time
        self.start_time = process.start_time.humanFormat()
        
        /// PIDs
        self.pid = process.pid
        self.ppid = process.ppid
        self.original_ppid = process.original_ppid
        self.group_id = process.group_id
        self.session_id = process.session_id
        
        /// Audit tokens
        if let audit_token = process.audit_token {
            let auditTokenObj = ESAuditToken(from: audit_token)
            self.audit_token_string = auditTokenObj.toString()
            self.audit_token = auditTokenObj
        }
        
        if let parent_audit_token = process.parent_audit_token {
            let parentAuditTokenObj = ESAuditToken(from: parent_audit_token)
            self.parent_audit_token = parentAuditTokenObj
            self.parent_audit_token_string = parentAuditTokenObj.toString()
        }
        
        if let responsible_audit_token = process.responsible_audit_token {
            let responsibleAuditTokenObj = ESAuditToken(from: responsible_audit_token)
            self.responsible_audit_token = responsibleAuditTokenObj
            self.responsible_audit_token_string = responsibleAuditTokenObj.toString()
        }
        
        
        /// Code signing
        self.codesigning_flags = process.codesigning_flags
        if let cdhash = process.cdhash {
            self.cdhash = cdhash
        }
        if let signing_id = process.signing_id {
            self.signing_id = signing_id
        }
        if let team_id = process.team_id {
            self.team_id = team_id
        }
        
        self.is_adhoc_signed = process.is_adhoc_signed
        
        // macOS 26
        if version >= 10 {
            if let cs_validation_category = process.cs_validation_category,
               let cs_validation_category_string = process.cs_validation_category_string {
                self.cs_validation_category = cs_validation_category
                self.cs_validation_category_string = cs_validation_category_string
            }
        }
        
        self.is_platform_binary = process.is_platform_binary
        self.is_es_client = process.is_es_client
        
        if let exe = process.executable {
            /// Executable
            self.executable = ESFile(from: exe)
            /// @note Enrichment - File Quarantine
            self.file_quarantine_type = process.file_quarantine_type.rawValue
            /// @note Enrichment - Codesigning Type
            self.codesigning_type = process.codesigning_type.rawValue
        }
        
        /// TTY
        if let tty = process.tty {
            self.tty = ESFile(from: tty)
        }
        
        /// @note Enrichment - User identification
        if let euid = process.euid {
            self.euid = Int64(euid)
        }
        if let euid_human = process.euid_human {
            self.euid_human = euid_human
        }
        
        if let ruid = process.ruid {
            self.ruid = Int64(ruid)
        }
        if let ruid_human = process.ruid_human {
            self.ruid_human = ruid_human
        }
    }
    
    // MARK: - Custom Core Data initilizer for ESProcess
    convenience init(
        from process: Process,
        version: Int,
        insertIntoManagedObjectContext context: NSManagedObjectContext!
    ) {
        let description = NSEntityDescription.entity(forEntityName: "ESProcess", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = process.id
        
        /// Time
        self.start_time = process.start_time.humanFormat()
        
        /// PIDs
        self.pid = process.pid
        self.ppid = process.ppid
        self.original_ppid = process.original_ppid
        self.group_id = process.group_id
        self.session_id = process.session_id
        
        /// Audit tokens
        if let audit_token = process.audit_token {
            let auditTokenObj = ESAuditToken(from: audit_token, insertIntoManagedObjectContext: context)
            self.audit_token_string = auditTokenObj.toString()
            self.audit_token = auditTokenObj
        }
        
        if let parent_audit_token = process.parent_audit_token {
            let parentAuditTokenObj = ESAuditToken(from: parent_audit_token, insertIntoManagedObjectContext: context)
            self.parent_audit_token = parentAuditTokenObj
            self.parent_audit_token_string = parentAuditTokenObj.toString()
        }
        
        if let responsible_audit_token = process.responsible_audit_token {
            let responsibleAuditTokenObj = ESAuditToken(from: responsible_audit_token, insertIntoManagedObjectContext: context)
            self.responsible_audit_token = responsibleAuditTokenObj
            self.responsible_audit_token_string = responsibleAuditTokenObj.toString()
        }
        
        
        /// Codesigning
        self.codesigning_flags = process.codesigning_flags
        if let signing_id = process.signing_id {
            self.signing_id = signing_id
        }
        if let team_id = process.team_id {
            self.team_id = team_id
        }
        if let cdhash = process.cdhash {
            self.cdhash = cdhash
        }
        
        self.is_adhoc_signed = process.is_adhoc_signed
        
        // macOS 26
        if version >= 10 {
            if let cs_validation_category = process.cs_validation_category,
               let cs_validation_category_string = process.cs_validation_category_string {
                self.cs_validation_category = cs_validation_category
                self.cs_validation_category_string = cs_validation_category_string
            }
        }
        
        
        self.is_platform_binary = process.is_platform_binary
        self.is_es_client = process.is_es_client
        
        if let exe = process.executable {
            /// Executable
            self.executable = ESFile(
                from: exe,
                insertIntoManagedObjectContext: context
            )
            /// @note Enrichment - File Quarantine
            self.file_quarantine_type = process.file_quarantine_type.rawValue
            /// @note Enrichment - Codesigning type
            self.codesigning_type = process.codesigning_type.rawValue
        }
        
        /// TTY
        if let tty = process.tty {
            self.tty = ESFile(
                from: tty,
                insertIntoManagedObjectContext: context
            )
        }
        
        /// User identification
        if let euid = process.euid {
            self.euid = Int64(euid)
        }
        if let euid_human = process.euid_human {
            self.euid_human = euid_human
        }
        
        if let ruid = process.ruid {
            self.ruid = Int64(ruid)
        }
        if let ruid_human = process.ruid_human {
            self.ruid_human = ruid_human
        }
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        try id = container.decode(UUID.self, forKey: .id)
        
        /// Time
        try start_time = container.decode(String.self, forKey: .start_time)
        
        /// PIDs
        try pid = container.decode(Int32.self, forKey: .pid)
        try ppid = container.decode(Int32.self, forKey: .ppid)
        try original_ppid = container.decode(Int32.self, forKey: .original_ppid)
        try group_id = container.decode(Int32.self, forKey: .group_id)
        try session_id = container.decode(Int32.self, forKey: .session_id)
        
        /// Codesigning
        try codesigning_flags = container.decode(Int64.self, forKey: .codesigning_flags)
        try signing_id = container.decodeIfPresent(String.self, forKey: .signing_id)
        try team_id = container.decodeIfPresent(String.self, forKey: .team_id)
        
        try is_adhoc_signed = container
            .decode(Bool.self, forKey: .is_adhoc_signed)
        
        if #available(macOS 26.0, *) {
            try cs_validation_category = container.decodeIfPresent(Int32.self, forKey: .cs_validation_category) ?? 0
            try cs_validation_category_string = container.decodeIfPresent(String.self, forKey: .cs_validation_category_string)
        }
        
        try cdhash = container.decodeIfPresent(String.self, forKey: .cdhash)
        try is_platform_binary = container
            .decode(Bool.self, forKey: .is_platform_binary)
        try is_es_client = container.decode(Bool.self, forKey: .is_es_client)
        
        /// Audit tokens
        try audit_token = container
            .decode(ESAuditToken.self, forKey: .audit_token)
        try audit_token_string = container.decode(String.self, forKey: .audit_token_string)
        try parent_audit_token = container.decode(ESAuditToken.self, forKey: .parent_audit_token)
        try parent_audit_token_string = container.decode(String.self, forKey: .parent_audit_token_string)
        try responsible_audit_token = container.decode(ESAuditToken.self, forKey: .responsible_audit_token)
        try responsible_audit_token_string = container.decode(String.self, forKey: .responsible_audit_token_string)
        
        /// Executable
        try executable = container.decode(ESFile.self, forKey: .executable)
        
        /// TTY
        try tty = container.decode(ESFile.self, forKey: .tty)
        
        /// @note Enrichment - File Quarantine
        try file_quarantine_type = container
            .decode(String.self, forKey: .file_quarantine_type)
        
        /// @note Enrichment - Codesigning type
        try codesigning_type = container
            .decode(String.self, forKey: .codesigning_type)
        
        /// @note - Enrichment user identification
        try euid = container.decode(Int64.self, forKey: .euid)
        try ruid = container.decode(Int64.self, forKey: .ruid)
        try euid_human = container
            .decodeIfPresent(String.self, forKey: .euid_human)
        try ruid_human = container.decodeIfPresent(String.self, forKey: .ruid_human)
    }

}

// MARK: - Encodable conformance
extension ESProcess: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        /// Time
        try container.encode(start_time, forKey: .start_time)
        
        /// PIDs
        try container.encode(pid, forKey: .pid)
        try container.encode(ppid, forKey: .ppid)
        try container.encode(original_ppid, forKey: .original_ppid)
        try container.encode(group_id, forKey: .group_id)
        try container.encode(session_id, forKey: .session_id)
        
        /// Audit tokens
        try container.encode(audit_token, forKey: .audit_token)
        try container.encode(audit_token_string, forKey: .audit_token_string)
        try container.encode(parent_audit_token, forKey: .parent_audit_token)
        try container.encode(parent_audit_token_string, forKey: .parent_audit_token_string)
        try container
            .encode(responsible_audit_token, forKey: .responsible_audit_token)
        try container
            .encode(
                responsible_audit_token_string,
                forKey: .responsible_audit_token_string
            )
        
        /// Codesigning
        try container.encode(codesigning_flags, forKey: .codesigning_flags)
        try container.encode(signing_id, forKey: .signing_id)
        try container.encode(team_id, forKey: .team_id)
        try container.encode(cdhash, forKey: .cdhash)
        try container.encode(is_adhoc_signed, forKey: .is_adhoc_signed)
        
        if #available(macOS 26.0, *) {
            try container.encode(cs_validation_category, forKey: .cs_validation_category)
            try container.encodeIfPresent(cs_validation_category_string, forKey: .cs_validation_category_string)
        }
        
        try container.encode(cs_validation_category, forKey: .cs_validation_category)
        try container.encodeIfPresent(cs_validation_category_string, forKey: .cs_validation_category_string)
        
        try container.encode(is_es_client, forKey: .is_es_client)
        try container.encode(is_platform_binary, forKey: .is_platform_binary)
        
        /// Executable
        try container.encode(executable, forKey: .executable)
        try container
            .encode(file_quarantine_type, forKey: .file_quarantine_type)
        try container
            .encode(codesigning_type, forKey: .codesigning_type)
        
        /// TTY
        try container.encode(tty, forKey: .tty)
        
        /// @note Enrichment - User identification
        try container.encode(euid, forKey: .euid)
        try container.encode(ruid, forKey: .ruid)
        try container.encode(euid_human, forKey: .euid_human)
        try container.encode(ruid_human, forKey: .ruid_human)
    }
}
