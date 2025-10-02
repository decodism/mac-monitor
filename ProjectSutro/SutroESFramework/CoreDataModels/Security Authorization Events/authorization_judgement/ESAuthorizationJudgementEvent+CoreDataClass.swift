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
        case id
        case instigator
        case petitioner
        case results
        case return_code
        case result_count
        case instigator_token
        case petitioner_token
    }
    
    public var results: [ESAuthorizationResult] {
        get {
            guard let data = resultsData else { return [] }
            return (try? JSONDecoder().decode([ESAuthorizationResult].self, from: data)) ?? []
        }
        set {
            resultsData = try? JSONEncoder().encode(newValue)
        }
    }
    
    convenience init(from message: Message) {
        let event: AuthorizationJudgementEvent = message.event.authorization_judgement!
        self.init()
        self.id = event.id
        
        self.return_code = Int32(event.return_code)
        self.result_count = Int32(event.result_count)
        self.results = event.results
        
        if let instigator = event.instigator {
            self.instigator = ESProcess(from: instigator, version: message.version)
            if let instigator_token = event.instigator_token {
                self.instigator_token = ESAuditToken(from: instigator_token)
            }
        }
        
        if let petitioner = event.petitioner {
            self.petitioner = ESProcess(from: petitioner, version: message.version)
            if let petitioner_token = event.petitioner_token {
                self.petitioner_token = ESAuditToken(from: petitioner_token)
            }
        }
    }
    
    convenience init(from message: Message, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let event: AuthorizationJudgementEvent = message.event.authorization_judgement!
        let description = NSEntityDescription.entity(forEntityName: "ESAuthorizationJudgementEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = event.id
        
        self.return_code = Int32(event.return_code)
        self.result_count = Int32(event.result_count)
        self.results = event.results
        
        if let instigator = event.instigator {
            self.instigator = ESProcess(from: instigator, version: message.version, insertIntoManagedObjectContext: context)
            if let instigator_token = event.instigator_token {
                self.instigator_token = ESAuditToken(from: instigator_token, insertIntoManagedObjectContext: context)
            }
        }
        
        if let petitioner = event.petitioner {
            self.petitioner = ESProcess(from: petitioner, version: message.version, insertIntoManagedObjectContext: context)
            if let petitioner_token = event.petitioner_token {
                self.petitioner_token = ESAuditToken(from: petitioner_token, insertIntoManagedObjectContext: context)
            }
        }
    }
    
    
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try return_code = container.decode(Int32.self, forKey: .return_code)
        try result_count = container.decode(Int32.self, forKey: .result_count)
        try results = container.decode([ESAuthorizationResult].self, forKey: .results)
        
        try instigator = container.decodeIfPresent(ESProcess.self, forKey: .instigator)
        try petitioner = container.decodeIfPresent(ESProcess.self, forKey: .petitioner)
        
        try instigator_token = container.decodeIfPresent(ESAuditToken.self, forKey: .instigator_token)
        try petitioner_token = container.decodeIfPresent(ESAuditToken.self, forKey: .petitioner_token)
    }
}

extension ESAuthorizationJudgementEvent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(return_code, forKey: .return_code)
        try container.encode(result_count, forKey: .result_count)
        try container.encode(results, forKey: .results)
        
        try container.encode(instigator, forKey: .instigator)
        try container.encode(petitioner, forKey: .petitioner)
        
        try container.encode(instigator_token, forKey: .instigator_token)
        try container.encode(petitioner_token, forKey: .petitioner_token)
    }
}
