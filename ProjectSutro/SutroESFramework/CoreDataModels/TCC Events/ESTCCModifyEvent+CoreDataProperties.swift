//
//  ESTCCModifyEvent+CoreDataProperties.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 8/15/25.
//
//

public import Foundation
public import CoreData

extension ESTCCModifyEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESTCCModifyEvent> {
        return NSFetchRequest<ESTCCModifyEvent>(entityName: "ESTCCModifyEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var service: String
    @NSManaged public var identity: String
    @NSManaged public var identity_type: Int32
    @NSManaged public var update_type: Int32
    @NSManaged public var right: Int32
    @NSManaged public var reason: Int32
    @NSManaged public var identity_type_string: String
    @NSManaged public var update_type_string: String
    @NSManaged public var right_string: String
    @NSManaged public var reason_string: String
    
    @NSManaged public var instigator_token: ESAuditToken?
    @NSManaged public var instigator: ESProcess?
    
    @NSManaged public var responsible_token: ESAuditToken?
    @NSManaged public var responsible: ESProcess?

}

extension ESTCCModifyEvent : Identifiable {

}
