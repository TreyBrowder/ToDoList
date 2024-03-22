//
//  ViewController.swift
//  ToDoList
//
//  Created by Trey Browder on 3/22/24.
//

import UIKit

class ViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func getAllTasks(name: String){
        do {
            let tasks = try context.fetch(ToDoListTask.fetchRequest())
        }
        catch {
            //error goes here
            
        }
        
    }
    
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
    
    func deleteTask(task: ToDoListTask) {
        context.delete(task)
        
        do {
            try context.save()
        }
        catch {
            //handle error
        }
    }
    
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

