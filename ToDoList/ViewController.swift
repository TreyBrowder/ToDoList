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
    
    private var tasksData = [ToDoListTask]()
    
    ///tableview needed to display task list
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "taskCell")
       
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "TO DO LIST"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        
    }
    
    
    
// MARK: - Core Data Methods
    
    ///method to return list of all task
    func getAllTasks(name: String){
        do {
            tasksData = try context.fetch(ToDoListTask.fetchRequest())
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
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

///Extension for the data source and delegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {

//MARK: Data source methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasksData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        
        cell.textLabel?.text = task.name
        
        return cell
    }
    
//MARK: Delegate methods
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //may not use this method
//    }
}
