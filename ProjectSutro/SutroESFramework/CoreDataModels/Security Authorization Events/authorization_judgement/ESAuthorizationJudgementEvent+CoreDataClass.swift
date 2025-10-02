//
//  ESAuthorizationJudgementEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 6/28/23.
//
//

import Foundation
import CoreData


@objc(ESAuthorizationJudgementEvent)
public class ESAuthorizationJudgementEvent: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, instigator_process_name, instigator_process_path, instigator_process_audit_token, instigator_process_signing_id, petitioner_process_name, petitioner_process_path, petitioner_process_audit_token, petitioner_process_signing_id, return_code, result_count, results
    }
    
    convenience init(from message: Message) {
        let authorizationJudgemenentEvent: AuthorizationJudgementEvent = message.event.authorization_judgement!
        self.init()
        
        self.id = message.id
        self.instigator_process_name = authorizationJudgemenentEvent.instigator_process_name
        self.instigator_process_path = authorizationJudgemenentEvent.instigator_process_path
        self.instigator_process_audit_token = authorizationJudgemenentEvent.instigator_process_audit_token
        self.instigator_process_signing_id = authorizationJudgemenentEvent.instigator_process_signing_id
        self.petitioner_process_name = authorizationJudgemenentEvent.petitioner_process_name
        self.petitioner_process_path = authorizationJudgemenentEvent.petitioner_process_path
        self.petitioner_process_audit_token = authorizationJudgemenentEvent.petitioner_process_audit_token
        self.petitioner_process_signing_id = authorizationJudgemenentEvent.petitioner_process_signing_id
        self.return_code = Int32(authorizationJudgemenentEvent.return_code)
        self.result_count = Int32(authorizationJudgemenentEvent.result_count)
        self.results = authorizationJudgemenentEvent.results
    }
    
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let authorizationJudgementEvent: AuthorizationJudgementEvent = message.event.authorization_judgement!
        let description = NSEntityDescription.entity(forEntityName: "ESAuthorizationJudgementEvent", in: context)!
        self.init(entity: description, insertInto: context)
        
        self.id = message.id
        self.instigator_process_name = authorizationJudgementEvent.instigator_process_name
        self.instigator_process_path = authorizationJudgementEvent.instigator_process_path
        self.instigator_process_audit_token = authorizationJudgementEvent.instigator_process_audit_token
        self.instigator_process_signing_id = authorizationJudgementEvent.instigator_process_signing_id
        self.petitioner_process_name = authorizationJudgementEvent.petitioner_process_name
        self.petitioner_process_path = authorizationJudgementEvent.petitioner_process_path
        self.petitioner_process_audit_token = authorizationJudgementEvent.petitioner_process_audit_token
        self.petitioner_process_signing_id = authorizationJudgementEvent.petitioner_process_signing_id
        self.return_code = Int32(authorizationJudgementEvent.return_code)
        self.result_count = Int32(authorizationJudgementEvent.result_count)
        self.results = authorizationJudgementEvent.results
    }
    
    
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try instigator_process_name = container.decode(String.self, forKey: .instigator_process_name)
        try instigator_process_path = container.decode(String.self, forKey: .instigator_process_path)
        try instigator_process_audit_token = container.decode(String.self, forKey: .instigator_process_audit_token)
        try instigator_process_signing_id = container.decode(String.self, forKey: .instigator_process_signing_id)
        try petitioner_process_name = container.decode(String.self, forKey: .petitioner_process_name)
        try petitioner_process_path = container.decode(String.self, forKey: .petitioner_process_path)
        try petitioner_process_audit_token = container.decode(String.self, forKey: .petitioner_process_audit_token)
        try petitioner_process_signing_id = container.decode(String.self, forKey: .petitioner_process_signing_id)
        try return_code = container.decode(Int32.self, forKey: .return_code)
        try result_count = container.decode(Int32.self, forKey: .result_count)
        try results = container.decode(String.self, forKey: .results)
    }
}

extension ESAuthorizationJudgementEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(instigator_process_name, forKey: .instigator_process_name)
        try container.encode(instigator_process_path, forKey: .instigator_process_path)
        try container.encode(instigator_process_audit_token, forKey: .instigator_process_audit_token)
        try container.encode(instigator_process_signing_id, forKey: .instigator_process_signing_id)
        try container.encode(petitioner_process_name, forKey: .petitioner_process_name)
        try container.encode(petitioner_process_path, forKey: .petitioner_process_path)
        try container.encode(petitioner_process_audit_token, forKey: .petitioner_process_audit_token)
        try container.encode(petitioner_process_signing_id, forKey: .petitioner_process_signing_id)
        try container.encode(return_code, forKey: .return_code)
        try container.encode(result_count, forKey: .result_count)
        try container.encode(results, forKey: .results)
    }
}
