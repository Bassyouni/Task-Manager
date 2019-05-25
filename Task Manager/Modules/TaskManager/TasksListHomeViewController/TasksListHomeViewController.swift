//
//  TasksListHomeViewController.swift
//  Task Manager
//
//  Created by Bassyouni on 5/24/19.
//  Copyright © 2019 Bassyouni. All rights reserved.
//

import UIKit

class TasksListHomeViewController: BaseViewController {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - static functions
    static func instantiateFromStoryboard() -> TasksListHomeViewController {
        let storyboard = UIStoryboard(name: "TaskManager", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! TasksListHomeViewController
    }
    
    
    // MARK: - variables
    var tasksArray = [TaskModel]()
    var groupedTasks =  [[TaskModel]]()
    let completedStringConstant = "Completed"
    let pendingStringConstant = "Pending"
    
    
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configueData()
        tableView.reloadData()
    }
    
    
    // MARK: - initialization
    fileprivate func configureUI() {
        tableView.register(UINib(nibName: TaskTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: TaskTableViewCell.cellIdentifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Tasks"
    }
    
    fileprivate func configueData() {
        tasksArray = CoreDataManager.shared.fetchModels(entityType: TaskModel.self)
        self.groupData()
        
        if tasksArray.count > 0 {
            tableView.isHidden = false
            self.view.removeEmptyState()
        } else {
            tableView.isHidden = true
            self.view.showEmptyState(message: "Add A Task\nTo Show Here")
        }
    }
    
    
    // MARK: - actions
    @IBAction func addTaskButtonPressed(_ sender: Any) {
        navigateToTaskAddUpdateViewController()
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        TypePickerViewController.ShowPickerWith(title: "123", items: ["1","2","3"]) { (_, _) in
            
        }
    }
    
    fileprivate func handleCellSelection(at indexPath: IndexPath) {
        navigateToTaskAddUpdateViewController(withModel: groupedTasks[indexPath.section][indexPath.row])
    }
    
    
    // MARK: - helpers
    fileprivate func navigateToTaskAddUpdateViewController(withModel model: TaskModel? = nil) {
        let viewController = TaskAddUpdateViewController.instantiateFromStoryboard()
        viewController.taskModel = model
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    fileprivate func removeTask(atIndexPath indexPath: IndexPath) {
        CoreDataManager.shared.deleteObject(groupedTasks[indexPath.section][indexPath.row]) { (_) in
            
        }
    }
    
    fileprivate func groupData() {
        let groupedTasksDictionary = Dictionary(grouping: tasksArray) { (model) -> String in
            if let date = model.completionDate {
                if date <= Date() {
                    return completedStringConstant
                }
            }
            return pendingStringConstant
        }
        
        groupedTasks.removeAll()
        groupedTasks.append(groupedTasksDictionary[pendingStringConstant] ?? [])
        groupedTasks.append(groupedTasksDictionary[completedStringConstant] ?? [])

    }
    
}

// MARK: - table
extension TasksListHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedTasks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedTasks[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.cellIdentifier, for: indexPath) as? TaskTableViewCell
        {
            cell.bindUI(taskModel: groupedTasks[indexPath.section][indexPath.row], isCompleted: indexPath.section == 1)  
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleCellSelection(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            self.removeTask(atIndexPath: indexPath)
            self.configueData()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return (groupedTasks[0].count > 0) ? pendingStringConstant : nil
        case 1:
            return (groupedTasks[1].count > 0) ? completedStringConstant : nil
        default:
            return nil
        }
    }
}


