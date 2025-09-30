//
//  ESProcessExitEvent+CoreDataProperties.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 11/15/22.
//
//

import Foundation
import CoreData


extension ESProcessExitEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ESProcessExitEvent> {
        return NSFetchRequest<ESProcessExitEvent>(entityName: "ESProcessExitEvent")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var stat: Int32
    
}

extension ESProcessExitEvent : Identifiable {

}
