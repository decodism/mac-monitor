//
//  ESLaunchItemRemoveEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 12/14/22.
//
//

import Foundation
import CoreData


extension ESLaunchItemRemoveEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESLaunchItemRemoveEvent> {
        return NSFetchRequest<ESLaunchItemRemoveEvent>(entityName: "ESLaunchItemRemoveEvent")
    }

    @NSManaged public var id: UUID?
    
    @NSManaged public var instigator: ESProcess?
    @NSManaged public var instigator_token: ESAuditToken?
    
    @NSManaged public var app: ESProcess?
    @NSManaged public var app_token: ESAuditToken?
    
    @NSManaged public var item: ESLaunchItem

}

extension ESLaunchItemRemoveEvent : Identifiable {

}
