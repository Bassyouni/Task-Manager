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
    
    
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        configueData()
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
        
        if tasksArray.count > 0 {
            tableView.reloadData()
            tableView.isHidden = false
        } else {
            tableView.isHidden = true
            self.view.showEmptyState(message: "Add A Task\nToShow Here")
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
    
    fileprivate func handleCellSelection(at index: Int) {
        navigateToTaskAddUpdateViewController(withModel: 1 as AnyObject)
    }
    
    
    // MARK: - helpers
    fileprivate func navigateToTaskAddUpdateViewController(withModel model: AnyObject? = nil) {
        let viewController = TaskAddUpdateViewController.instantiateFromStoryboard()
        viewController.taskModel = model
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - table
extension TasksListHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.cellIdentifier, for: indexPath) as? TaskTableViewCell
        {
            cell.taskModel = tasksArray[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleCellSelection(at: indexPath.row)
    }
}


