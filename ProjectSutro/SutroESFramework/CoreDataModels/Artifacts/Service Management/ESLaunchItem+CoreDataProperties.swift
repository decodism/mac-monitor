//
//  ESLaunchItem+CoreDataProperties.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 9/26/25.
//
//

import Foundation
import CoreData


extension ESLaunchItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESLaunchItem> {
        return NSFetchRequest<ESLaunchItem>(entityName: "ESLaunchItem")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var item_type: Int16
    @NSManaged public var item_type_string: String
    @NSManaged public var item_url: String
    @NSManaged public var item_path: String
    @NSManaged public var app_url: String?
    @NSManaged public var app_path: String?
    @NSManaged public var legacy: Bool
    @NSManaged public var managed: Bool
    @NSManaged public var uid: Int64
    @NSManaged public var plist_contents: String?
    @NSManaged public var uid_human: String?

}

extension ESLaunchItem : Identifiable {

}
