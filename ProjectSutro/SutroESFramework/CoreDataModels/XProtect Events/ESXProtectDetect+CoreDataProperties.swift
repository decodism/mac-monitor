//
//  ESXProtectDetect+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 12/30/22.
//
//

import Foundation
import CoreData


extension ESXProtectDetect {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESXProtectDetect> {
        return NSFetchRequest<ESXProtectDetect>(entityName: "ESXProtectDetect")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var signature_version: String
    @NSManaged public var malware_identifier: String
    @NSManaged public var incident_identifier: String
    @NSManaged public var detected_path: String
    @NSManaged public var detected_executable: String?

}

extension ESXProtectDetect : Identifiable {

}
