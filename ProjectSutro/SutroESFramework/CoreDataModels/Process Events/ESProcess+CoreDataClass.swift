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
public class ESProcess: NSManagedObject {
    convenience init(
        from process: Process,
        version: Int,
        insertIntoManagedObjectContext context: NSManagedObjectContext
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
}

// MARK: - Encodable conformance
extension ESProcess: Encodable {
    enum CodingKeys: String, CodingKey {
        case id, start_time, pid, ppid, original_ppid, group_id, session_id, audit_token, audit_token_string, parent_audit_token, parent_audit_token_string, responsible_audit_token, responsible_audit_token_string, codesigning_flags, cdhash, signing_id, team_id, is_adhoc_signed, is_platform_binary, is_es_client, cs_validation_category, cs_validation_category_string, executable, file_quarantine_type, codesigning_type, tty, euid, euid_human, ruid, ruid_human
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(start_time, forKey: .start_time)
        
        try container.encode(pid, forKey: .pid)
        try container.encode(ppid, forKey: .ppid)
        try container.encode(original_ppid, forKey: .original_ppid)
        try container.encode(group_id, forKey: .group_id)
        try container.encode(session_id, forKey: .session_id)
        
        try container.encodeIfPresent(audit_token, forKey: .audit_token)
        try container.encodeIfPresent(audit_token_string, forKey: .audit_token_string)
        try container.encodeIfPresent(parent_audit_token, forKey: .parent_audit_token)
        try container.encodeIfPresent(parent_audit_token_string, forKey: .parent_audit_token_string)
        try container.encodeIfPresent(responsible_audit_token, forKey: .responsible_audit_token)
        try container.encodeIfPresent(responsible_audit_token_string, forKey: .responsible_audit_token_string)
        
        try container.encode(codesigning_flags, forKey: .codesigning_flags)
        try container.encodeIfPresent(signing_id, forKey: .signing_id)
        try container.encodeIfPresent(team_id, forKey: .team_id)
        try container.encodeIfPresent(cdhash, forKey: .cdhash)
        try container.encode(is_adhoc_signed, forKey: .is_adhoc_signed)
        
        if #available(macOS 14.0, *) { // Adjust for actual availability if different
            try container.encode(cs_validation_category, forKey: .cs_validation_category)
            try container.encodeIfPresent(cs_validation_category_string, forKey: .cs_validation_category_string)
        }
        
        try container.encode(is_es_client, forKey: .is_es_client)
        try container.encode(is_platform_binary, forKey: .is_platform_binary)
        
        try container.encodeIfPresent(executable, forKey: .executable)
        try container.encodeIfPresent(file_quarantine_type, forKey: .file_quarantine_type)
        try container.encodeIfPresent(codesigning_type, forKey: .codesigning_type)
        
        try container.encodeIfPresent(tty, forKey: .tty)
        
        try container.encode(euid, forKey: .euid)
        try container.encode(ruid, forKey: .ruid)
        try container.encodeIfPresent(euid_human, forKey: .euid_human)
        try container.encodeIfPresent(ruid_human, forKey: .ruid_human)
    }
}
