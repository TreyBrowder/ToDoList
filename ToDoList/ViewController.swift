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
    
    private var dueDateTextField: UITextField?
    
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
        
        //set up button to add a task to the UI
        taskSetUp()
        
    }
    
    private func taskSetUp(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "New Task",
                                      message: "Enter new task to do",
                                      preferredStyle: .alert)
        
        //text field for the task name
        alert.addTextField { taskName in
            taskName.placeholder = "Name of task to do"
        }
        
        //create a larger container to show date picker then add it to the subview
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: (view.bounds.width)/4, height: (view.bounds.height)/4))
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: (view.bounds.width)/4, height: (view.bounds.height)/4))
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        containerView.addSubview(datePicker)
        //text field for the due date
        alert.addTextField { [weak self] taskDueDate in
            
            guard let self = self else {
                return
            }
            
            self.dueDateTextField = taskDueDate
            taskDueDate.placeholder = "MM/DD/YYYY"
            taskDueDate.inputView = containerView
            
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done",
                                             style: .plain,
                                             target: self,
                                             action: #selector(self.dismissDatePicker))
            toolbar.setItems([doneButton], animated: false)
            taskDueDate.inputAccessoryView = toolbar
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let self = self else {
                return
            }
            
            guard let taskNameTextField = alert.textFields?.first, let text = taskNameTextField.text, !text.isEmpty else {
                print("----- LOG -----")
                print("Method: didTapAdd")
                print("Error: text to add new task was empty")
                return
            }
            
            guard let taskDueDateField = alert.textFields?.last, let taskDueDateStr = taskDueDateField.text, !taskDueDateStr.isEmpty else {
                print("----- LOG -----")
                print("Method: didTapAdd")
                print("Error: text to add new task due date was empty")
                return
            }
            
            //Convert the date string back to a date object to save in core data
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/DD/YYYY"
            if let taskDueDate = dateFormatter.date(from: taskDueDateStr) {
                self.createTask(name: text, dueDate: taskDueDate)
            } else {
                print("Invalid date format")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    ///selector method when users taps done to dismiss the date picker
    @objc private func dismissDatePicker(){
        guard let alert = presentedViewController as? UIAlertController,
              let taskDueDateField = alert.textFields?.last else {
            return
        }
        
        // Get the date picker from the containerView
        if let containerView = taskDueDateField.inputView,
           let datePicker = containerView.subviews.first as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            taskDueDateField.text = dateFormatter.string(from: datePicker.date)
        }
        
        taskDueDateField.endEditing(true)
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
            print("Couldnt save created task")
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
            print("Couldnt delete task")
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
            print("Couldn't update task")
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
