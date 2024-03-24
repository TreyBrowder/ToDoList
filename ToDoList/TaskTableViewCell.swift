//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Trey Browder on 3/24/24.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    let taskNameLabel = UILabel()
    let createdDtLabel = UILabel()
    let dueByDtLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        //set the font size/weight
        taskNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        createdDtLabel.font = UIFont.systemFont(ofSize: 10)
        dueByDtLabel.font = UIFont.systemFont(ofSize: 10)
        
        //enable dynamic postioning
        taskNameLabel.translatesAutoresizingMaskIntoConstraints = false
        createdDtLabel.translatesAutoresizingMaskIntoConstraints = false
        dueByDtLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //add to the cell
        contentView.addSubview(taskNameLabel)
        contentView.addSubview(createdDtLabel)
        contentView.addSubview(dueByDtLabel)
        
        //Dynamically set positioning
        NSLayoutConstraint.activate([
            taskNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            taskNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26),
            createdDtLabel.topAnchor.constraint(equalTo: taskNameLabel.bottomAnchor, constant: 10),
            createdDtLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26),
            dueByDtLabel.topAnchor.constraint(equalTo: createdDtLabel.bottomAnchor, constant: 4),
            dueByDtLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
