//
//  RCESProcessExecEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 11/15/22.
//
//

import Foundation
import CoreData
import OSLog

@objc(ESProcessExecEvent)
public class ESProcessExecEvent: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id, pid, target_proc_audit_token_string, target_proc_parent_audit_token_string, target_proc_responsible_audit_token_string, allow_jit, command_line, get_task_allow, is_adhoc_signed, is_es_client, is_platform_binary, process_name, process_path, rootless, signing_id, skip_lv, team_id, start_time, cdhash, certificate_chain, ruid, euid, ruid_human, euid_human, file_quarantine_type, cs_type, group_id, target, dyld_exec_path, script, cwd, last_fd, image_cputype, image_cpusubtype, fds, args, env
    }
    
    public var args: [String] {
        get {
            guard let data = argsData else { return [] }
            return (try? JSONDecoder().decode([String].self, from: data)) ?? []
        }
        set {
            argsData = try? JSONEncoder().encode(newValue)
        }
    }

    public var env: [String] {
        get {
            guard let data = envData else { return [] }
            return (try? JSONDecoder().decode([String].self, from: data)) ?? []
        }
        set {
            envData = try? JSONEncoder().encode(newValue)
        }
    }

    
    public var fds: [FileDescriptor] {
        get {
            guard let data = fdsData else { return [] }
            return (try? JSONDecoder().decode([FileDescriptor].self, from: data)) ?? []
        }
        set {
            fdsData = try? JSONEncoder().encode(newValue)
        }
    }
    
    public var certificate_chain: [X509Cert] {
        get {
            guard let data = certificateChainData else { return [] }
            return (try? JSONDecoder().decode([X509Cert].self, from: data)) ?? []
        }
        set {
            certificateChainData = try? JSONEncoder().encode(newValue)
        }
    }
    
    // MARK: - Custom initilizer for ESProcessExecEvent during heavy flows
    convenience init(from message: Message) {
        let execEvent: ProcessExecEvent = message.event.exec!
        self.init()
        self.id = execEvent.id
        
        // MARK: - Conform to ESLogger
        self.dyld_exec_path = execEvent.dyld_exec_path // macOS 13.3+
        self.target = ESProcess(from: execEvent.target, version: message.version)
        
        self.fds = execEvent.fds
        
        if let script = execEvent.script {
            self.script = ESFile(from: script)
        }
        
        if let cwd = execEvent.cwd {
            self.cwd = ESFile(from: cwd)
        }
        
        if let last_fd = execEvent.last_fd {
            self.last_fd = Int64(last_fd)
        }
        
        if let image_cputype = execEvent.image_cputype {
            self.image_cputype = Int64(image_cputype)
        }
        if let image_cpusubtype = execEvent.image_cpusubtype {
            self.image_cpusubtype = Int64(image_cpusubtype)
        }
        
//        self.is_adhoc_signed = execEvent.is_adhoc_signed
//        self.allow_jit = execEvent.allow_jit
        
//        self.target_proc_audit_token_string = execEvent.target_proc_audit_token_string
//        self.target_proc_parent_audit_token_string = execEvent.target_proc_parent_audit_token_string
//        self.target_proc_responsible_audit_token_string = execEvent.target_proc_responsible_audit_token_string
        
        self.args = execEvent.args
        self.env = execEvent.env
        self.command_line = execEvent.command_line ?? ""
//        self.get_task_allow = execEvent.get_task_allow
        
//        self.is_es_client = execEvent.is_es_client
//        self.is_platform_binary = execEvent.is_platform_binary
        
//        self.file_quarantine_type = Int16(execEvent.file_quarantine_type)
//        self.cs_type = execEvent.cs_type
        
        
//        self.rootless = execEvent.rootless
//        self.signing_id = execEvent.signing_id ?? "None"
//        self.skip_lv = execEvent.skip_lv
//        self.team_id = execEvent.team_id
//        self.start_time = execEvent.start_time
//        self.cdhash = execEvent.cdhash
        self.certificate_chain = execEvent.certificate_chain
    }
    
    
    // MARK: - Custom Core Data initilizer for ESProcessExecEvent
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let execEvent: ProcessExecEvent = message.event.exec!
        let description = NSEntityDescription.entity(forEntityName: "ESProcessExecEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = execEvent.id
        
        // MARK: - Conform to ESLogger
        self.dyld_exec_path = execEvent.dyld_exec_path // macOS 13.3+
        self.target = ESProcess(
            from: execEvent.target,
            version: message.version,
            insertIntoManagedObjectContext: context
        )
        
        self.fds = execEvent.fds
        self.args = execEvent.args
        self.env = execEvent.env
        
        if let script = execEvent.script {
            self.script = ESFile(from: script, insertIntoManagedObjectContext: context)
        }
        
        if let cwd = execEvent.cwd {
            self.cwd = ESFile(from: cwd, insertIntoManagedObjectContext: context)
        }
        
        if let last_fd = execEvent.last_fd {
            self.last_fd = Int64(last_fd)
        }
        
        if let image_cputype = execEvent.image_cputype {
            self.image_cputype = Int64(image_cputype)
        }
        if let image_cpusubtype = execEvent.image_cpusubtype {
            self.image_cpusubtype = Int64(image_cpusubtype)
        }
    
//        self.allow_jit = execEvent.allow_jit
        self.command_line = execEvent.command_line ?? ""
//        self.get_task_allow = execEvent.get_task_allow
//        self.is_adhoc_signed = execEvent.is_adhoc_signed
//        self.is_es_client = execEvent.is_es_client
//        self.is_platform_binary = execEvent.is_platform_binary
        
//        self.target_proc_audit_token_string = execEvent.target_proc_audit_token_string
//        self.target_proc_parent_audit_token_string = execEvent.target_proc_parent_audit_token_string
//        self.target_proc_responsible_audit_token_string = execEvent.target_proc_responsible_audit_token_string
        
//        self.file_quarantine_type = Int16(execEvent.file_quarantine_type)
//        self.cs_type = execEvent.cs_type
        
//        self.rootless = execEvent.rootless
//        self.signing_id = execEvent.signing_id ?? "None"
//        self.skip_lv = execEvent.skip_lv
//        self.team_id = execEvent.team_id
//        self.start_time = execEvent.start_time
//        self.cdhash = execEvent.cdhash
        self.certificate_chain = execEvent.certificate_chain
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
//        try pid = container.decode(Int32.self, forKey: .pid)
        
        // MARK: - Conform to ESLogger
        try dyld_exec_path = container.decode(String.self, forKey: .dyld_exec_path) // macOS 13.3+
        try target = container.decode(ESProcess.self, forKey: .target)
        try script = container.decode(ESFile.self, forKey: .script)
        try cwd = container.decode(ESFile.self, forKey: .cwd)
        
        let fdsArray = try container.decode([FileDescriptor].self, forKey: .fds)
        self.fds = fdsArray
        
        self.args = try container.decode([String].self, forKey: .args)
        self.env = try container.decode([String].self, forKey: .env)

        try last_fd = container.decode(Int64.self, forKey: .last_fd)
        try image_cputype = container.decode(Int64.self, forKey: .image_cputype)
        try image_cpusubtype = container.decode(Int64.self, forKey: .image_cpusubtype)
        
        
        
        
        try command_line = container.decode(String.self, forKey: .command_line)
        
        
//        try target_proc_audit_token_string = container
//            .decode(String.self, forKey: .target_proc_audit_token_string)
//        try target_proc_parent_audit_token_string = container
//            .decode(String.self, forKey: .target_proc_parent_audit_token_string)
//        try target_proc_responsible_audit_token_string = container
//            .decode(
//                String.self,
//                forKey: .target_proc_responsible_audit_token_string
//            )
//        
//        try allow_jit = container.decode(Bool.self, forKey: .allow_jit)
//        try get_task_allow = container.decode(Bool.self, forKey: .get_task_allow)
//        try is_adhoc_signed = container.decode(Bool.self, forKey: .is_adhoc_signed)
//        try is_es_client = container.decode(Bool.self, forKey: .is_es_client)
//        try is_platform_binary = container.decode(Bool.self, forKey: .is_platform_binary)
//        try rootless = container.decode(Bool.self, forKey: .rootless)
        
        
//        try process_path = container.decode(String.self, forKey: .process_path)
//        try process_name = container.decode(String.self, forKey: .process_name)
//        try file_quarantine_type = container.decode(Int16.self, forKey: .file_quarantine_type)
//        try cs_type = container.decode(String.self, forKey: .cs_type)
        
//        try euid = container.decode(Int64.self, forKey: .euid)
//        try ruid = container.decode(Int64.self, forKey: .ruid)
//        try ruid_human = container.decode(String.self, forKey: .ruid_human)
//        try euid_human = container.decode(String.self, forKey: .euid_human)
//        try group_id = container.decode(Int32.self, forKey: .group_id)
        
        
//        try signing_id = container.decode(String.self, forKey: .signing_id)
//        try skip_lv = container.decode(Bool.self, forKey: .skip_lv)
//        try team_id = container.decode(String.self, forKey: .team_id)
//        try start_time = container.decode(String.self, forKey: .start_time)
//        try cdhash = container.decode(String.self, forKey: .cdhash)
        
        let certArray = try container.decode([X509Cert].self, forKey: .fds)
        self.certificate_chain = certArray
    }
}

// MARK: - Encodable conformance
extension ESProcessExecEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(pid, forKey: .pid)
//        try container
//            .encode(
//                target_proc_audit_token_string,
//                forKey: .target_proc_audit_token_string
//            )
//        try container
//            .encode(
//                target_proc_parent_audit_token_string,
//                forKey: .target_proc_parent_audit_token_string
//            )
//        try container
//            .encode(
//                target_proc_responsible_audit_token_string,
//                forKey: .target_proc_responsible_audit_token_string
//            )
        
        // MARK: - Conform to ESLogger
        try container.encode(target, forKey: .target)
        try container.encode(fds, forKey: .fds)
        try container.encode(script, forKey: .script)
        try container.encode(cwd, forKey: .cwd)
        try container.encode(last_fd, forKey: .last_fd)
        try container.encode(args, forKey: .args)
        try container.encode(env, forKey: .env)
        
        try container.encode(image_cputype, forKey: .image_cputype)
        try container.encode(image_cpusubtype, forKey: .image_cpusubtype)
        // @note don't include dyld_exec_path if we're not on macOS 13.3+
        if #available(macOS 13.3, *) {
            try container.encode(dyld_exec_path, forKey: .dyld_exec_path)
        }
        
        try container.encode(command_line, forKey: .command_line)
//        try container.encode(get_task_allow, forKey: .get_task_allow)
//        try container.encode(is_adhoc_signed, forKey: .is_adhoc_signed)
//        try container.encode(is_es_client, forKey: .is_es_client)
//        try container.encode(is_platform_binary, forKey: .is_platform_binary)
//        try container.encode(process_name, forKey: .process_name)
//        try container.encode(process_path, forKey: .process_path)
//        try container.encode(file_quarantine_type, forKey: .file_quarantine_type)
//        try container.encode(cs_type, forKey: .cs_type)
        
//        try container.encode(euid, forKey: .euid)
//        try container.encode(ruid, forKey: .ruid)
//        try container.encode(ruid_human, forKey: .ruid_human)
//        try container.encode(euid_human, forKey: .euid_human)
//        try container.encode(group_id, forKey: .group_id)
        
//        if self.rootless {
//            try container.encode(rootless, forKey: .rootless)
//        }
//        
//        if self.allow_jit {
//            try container.encode(allow_jit, forKey: .allow_jit)
//        }
//        
//        if self.get_task_allow {
//            try container.encode(get_task_allow, forKey: .get_task_allow)
//        }
//        
//        if self.skip_lv {
//            try container.encode(skip_lv, forKey: .skip_lv)
//        }
//        
//        try container.encode(signing_id, forKey: .signing_id)
//        
//        if self.team_id != nil {
//            try container.encode(team_id, forKey: .team_id)
//        }
//        
//        try container.encode(start_time, forKey: .start_time)
//        try container.encode(cdhash, forKey: .cdhash)
        
        // @note don't include the cert chain in json if there is none
        if !self.certificate_chain.isEmpty && self.certificate_chain.count != 0 {
            try container.encode(certificate_chain, forKey: .certificate_chain)
        }
    }
}
