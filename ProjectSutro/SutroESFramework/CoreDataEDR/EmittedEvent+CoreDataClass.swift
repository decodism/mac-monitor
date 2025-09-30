//
//  EmittedEvent+CoreDataClass.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 2/8/23.
//
//

import Foundation
import CoreData

@objc(EmittedEvent)
public class EmittedEvent: NSManagedObject {
    // MARK: - Custom Core Data initilizer for EmittedEvents
    convenience init(fromJSON event: String, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let description = NSEntityDescription.entity(forEntityName: "EmittedEvent", in: context)!
        self.init(entity: description, insertInto: context)
        self.timestamp = Int64(NSDate().timeIntervalSince1970)
        self.event_json = event
    }
}
