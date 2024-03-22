//
//  ViewController.swift
//  ToDoList
//
//  Created by Trey Browder on 3/22/24.
//

import UIKit

class ViewController: UIViewController {
    
    ///constant to access the persistent viewContext from the AppDelegate - Needed when working with CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
// MARK: - Core Data Methods
    
    ///method to return list of all task
    func getAllTasks(name: String){
        do {
            let tasks = try context.fetch(ToDoListTask.fetchRequest())
        }
        catch {
            //error goes here
            
        }
        
    }
    
    ///method to create a task
    func createTask(name: String, dueDate: Date){
        let newTask = ToDoListTask(context: context)
        newTask.name = name
        newTask.createdDate = Date()
        newTask.dueByDate = dueDate
        
        //save in the DB
        do {
            try context.save()
        }
        catch {
            //handle error here
        }
        
    }
    
    ///Method to delete a task
    func deleteTask(task: ToDoListTask) {
        context.delete(task)
        
        do {
            try context.save()
        }
        catch {
            //handle error
        }
    }
    
    ///Method to make a change to a task
    func updateTask(task: ToDoListTask, newName: String, newDueDate: Date){
        task.name = newName
        task.dueByDate = newDueDate
        
        do {
            try context.save()
        }
        catch {
            //handle error here
        }
    }

}

