//
//  ESGatekeeperUserOverrideEvent+CoreDataProperties.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 8/18/25.
//
//

public import Foundation
public import CoreData


public typealias ESGatekeeperUserOverrideEventCoreDataPropertiesSet = NSSet

extension ESGatekeeperUserOverrideEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESGatekeeperUserOverrideEvent> {
        return NSFetchRequest<ESGatekeeperUserOverrideEvent>(entityName: "ESGatekeeperUserOverrideEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var file_type: Int32
    @NSManaged public var file_type_string: String
    
    /// For some reason ESLogger as of macOS 26 does not emit this object...
    @NSManaged public var signing_info: ESSignedFileInfo?
    
    /// ESLogger for some reason reports when this is null as a string...
    /// Making non-optional to support this behavior.
    @NSManaged public var sha256: String
    
    /// We need to report the file union differently to the app to conform to ESLogger's oddness...
    @NSManaged public var file: ESFile?
    @NSManaged public var file_path: String?
}

extension ESGatekeeperUserOverrideEvent : Identifiable {

}
