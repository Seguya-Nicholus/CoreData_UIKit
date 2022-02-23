//
//  ToDoItem+CoreDataProperties.swift
//  CoreData_UIKit
//
//  Created by Nicholas Sseguya on 23/02/2022.
//
//

import Foundation
import CoreData


extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var createdAt: Date?

}

extension ToDoItem : Identifiable {

}
