//
//  ToDoListTask+CoreDataProperties.swift
//  ToDoList
//
//  Created by Trey Browder on 3/22/24.
//
//

import Foundation
import CoreData


extension ToDoListTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListTask> {
        return NSFetchRequest<ToDoListTask>(entityName: "ToDoListTask")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var dueByDate: Date?

}

extension ToDoListTask : Identifiable {

}
