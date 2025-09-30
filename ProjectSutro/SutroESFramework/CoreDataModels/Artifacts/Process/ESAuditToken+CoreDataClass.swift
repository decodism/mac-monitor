//
//  ESAuditToken+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 3/16/25.
//
//

import Foundation
import CoreData

@objc(ESAuditToken)
public class ESAuditToken: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, pid, euid, ruid, rgid, egid, asid, auid, pidversion
    }
    
    // MARK: - Custom initilizer for ESAuditToken
    convenience init(from token: AuditToken) {
        self.init()
        self.id = token.id
        
        self.pid = token.pid
        self.euid = token.euid
        self.ruid = token.ruid
        self.rgid = token.rgid
        self.egid = token.egid
        self.asid = token.asid
        self.auid = token.auid
        self.pidversion = token.pidversion
    }
    
    // MARK: - Custom Core Data initilizer for ESAuditToken
    convenience init(
        from token: AuditToken,
        insertIntoManagedObjectContext context: NSManagedObjectContext!
    ) {
        let description = NSEntityDescription.entity(forEntityName: "ESAuditToken", in: context)!
        self.init(entity: description, insertInto: context)
        self.id = token.id
        
        self.pid = token.pid
        self.euid = token.euid
        self.ruid = token.ruid
        self.rgid = token.rgid
        self.egid = token.egid
        self.asid = token.asid
        self.auid = token.auid
        self.pidversion = token.pidversion
    }
    
    // MARK: - Decodable conformance
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        
        try id = container.decode(UUID.self, forKey: .id)
        try pid = container.decode(Int32.self, forKey: .pid)
        try euid = container.decode(Int64.self, forKey: .euid)
        try ruid = container.decode(Int64.self, forKey: .ruid)
        try rgid = container.decode(Int64.self, forKey: .rgid)
        try egid = container.decode(Int64.self, forKey: .egid)
        try asid = container.decode(Int32.self, forKey: .asid)
        try auid = container.decode(Int64.self, forKey: .auid)
        try pidversion = container.decode(Int32.self, forKey: .pidversion)
    }

}

// MARK: - Encodable conformance and helper
extension ESAuditToken: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
        try container.encode(pid, forKey: .pid)
        try container.encode(euid, forKey: .euid)
        try container.encode(ruid, forKey: .ruid)
        try container.encode(rgid, forKey: .rgid)
        try container.encode(egid, forKey: .egid)
        try container.encode(asid, forKey: .asid)
        try container.encode(auid, forKey: .auid)
        try container.encode(pidversion, forKey: .pidversion)
    }
    
    public func toString() -> String {
        return "pid:\(pid), euid:\(euid), ruid:\(ruid), rgid:\(rgid), egid:\(egid), asid:\(asid), auid:\(auid), pidversion:\(pidversion)"
    }
}
