//
//  AuthorizationJudgementEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 6/28/23.
//

import Foundation


/**
 * @brief Describes, for a single right, the class of that right and if it was granted
 *
 * @field right_name            The name of the right being considered
 * @field rule_class            The class of the right being considered
 *                              The rule class determines how the operating system determines
 *                              if it should be granted or not
 * @field granted               Indicates if the right was granted or not
 */
public struct ESAuthorizationResult: Codable, Hashable {
    /*
     * The class of rules used to evaluate the petition for a specific authorization right
     */
    public var rule_class: String
    public var right_name: String
    public var granted: Bool
    
    public var description: String {
        return "Right name: \(right_name), Rule class: \(rule_class), Granted: \(granted)"
    }

    init(from esResult: es_authorization_result_t) {
        right_name = String(cString: esResult.right_name.data)
        granted = esResult.granted
        switch esResult.rule_class.rawValue {
        case ES_AUTHORIZATION_RULE_CLASS_USER.rawValue:
            /// Right is judged on user properties
            rule_class = "User"
        case ES_AUTHORIZATION_RULE_CLASS_RULE.rawValue:
            /// Right is judged by a tree of sub-rules
            rule_class = "Rule"
        case ES_AUTHORIZATION_RULE_CLASS_MECHANISM.rawValue:
            /// Right is judged by one or more plugins
            rule_class = "Mechanism"
        case ES_AUTHORIZATION_RULE_CLASS_ALLOW.rawValue:
            /// Right is always granted
            rule_class = "Allow"
        case ES_AUTHORIZATION_RULE_CLASS_DENY.rawValue:
            /// Right is always denied
            rule_class = "Deny"
        case ES_AUTHORIZATION_RULE_CLASS_UNKNOWN.rawValue:
            /// Right is unknown
            rule_class = "Unknown"
        case ES_AUTHORIZATION_RULE_CLASS_INVALID.rawValue:
            /// Right is invalid
            rule_class = "Invalid"
        default:
            rule_class = "Undefined"
        }
    }
}



public struct AuthorizationJudgementEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    public var instigator_process_name, instigator_process_path, instigator_process_audit_token, instigator_process_signing_id: String?
    public var petitioner_process_name, petitioner_process_path, petitioner_process_audit_token, petitioner_process_signing_id: String?
    public var return_code: Int
    public var result_count: Int
    public var results: String?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(instigator_process_name)
        hasher.combine(petitioner_process_name)
    }
    
    public static func == (lhs: AuthorizationJudgementEvent, rhs: AuthorizationJudgementEvent) -> Bool {
        if lhs.id == rhs.id && lhs.instigator_process_name == rhs.instigator_process_name && lhs.petitioner_process_name == rhs.petitioner_process_name {
            return true
        }
        
        return false
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let authJudgementEvent: es_event_authorization_judgement_t = rawMessage.pointee.event.authorization_judgement.pointee
        let instigatorProcess: es_process_t = authJudgementEvent.instigator!.pointee
        let petitionerProcess: es_process_t? = authJudgementEvent.petitioner?.pointee
        
        self.instigator_process_name = ""
        if instigatorProcess.executable.pointee.path.length > 0 {
            self.instigator_process_name = URL(filePath: String(cString: instigatorProcess.executable.pointee.path.data)).lastPathComponent
        }
        
        self.instigator_process_path = ""
        if instigatorProcess.executable.pointee.path.length > 0 {
            self.instigator_process_path = String(cString: instigatorProcess.executable.pointee.path.data)
        }
        
        self.instigator_process_signing_id = ""
        if instigatorProcess.signing_id.length > 0 {
            self.instigator_process_signing_id = String(cString: instigatorProcess.signing_id.data)
        }
        
        self.instigator_process_audit_token = ""
        self.instigator_process_audit_token = instigatorProcess.audit_token
            .toString()
        
        self.return_code = Int(authJudgementEvent.return_code)
        self.result_count = authJudgementEvent.result_count
        
        // Handling petitioner process
        if let petitionerProcess = petitionerProcess {
            self.petitioner_process_name = ""
            if petitionerProcess.executable.pointee.path.length > 0 {
                self.petitioner_process_name = URL(filePath: String(cString: petitionerProcess.executable.pointee.path.data)).lastPathComponent
            }
            
            self.petitioner_process_path = ""
            if petitionerProcess.executable.pointee.path.length > 0 {
                self.petitioner_process_path = String(cString: petitionerProcess.executable.pointee.path.data)
            }
            
            self.petitioner_process_signing_id = ""
            if petitionerProcess.signing_id.length > 0 {
                self.petitioner_process_signing_id = String(cString: petitionerProcess.signing_id.data)
            }
            
            self.petitioner_process_audit_token = ""
            self.petitioner_process_audit_token = petitionerProcess.audit_token
                .toString()
        }
        
        if let rawResults = authJudgementEvent.results {
            let esResults = (0..<self.result_count).map { index in
                return ESAuthorizationResult(from: rawResults[index])
            }
            self.results = esResults.map { $0.description }.joined(separator: "[::]")
        }
    }
}
