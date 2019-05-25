//
//  TaskAddUpdateViewController.swift
//  Task Manager
//
//  Created by Bassyouni on 5/24/19.
//  Copyright © 2019 Bassyouni. All rights reserved.
//

import UIKit

class TaskAddUpdateViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var taskNameTextField: RoundedTextField!
    @IBOutlet weak var complitionDateTextField: RoundedTextField!
    @IBOutlet weak var categoryTextField: RoundedTextField!
    @IBOutlet weak var complitionDateButton: UIButton!
    @IBOutlet weak var categoryDropDownButton: UIButton!
    @IBOutlet weak var categoryColorView: RoundedShadowView!
    @IBOutlet weak var saveEditButton: RoundedShadowButton!
    @IBOutlet weak var deleteButton: RoundedShadowButton!
    
    
    // MARK: - variables
    var taskModel: TaskModel?
    
    private var selectedCategoryColor: SystemColors = .orange
    private var selectedCategoryName: String?
    private var selectedCategoryModel: CategoryModel?
    
    private var categoriesArray = [CategoryModel]()
    
    
    // MARK: - static methods
    static func instantiateFromStoryboard() -> TaskAddUpdateViewController {
        let storyboard = UIStoryboard(name: "TaskManager", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! TaskAddUpdateViewController
    }
    
    
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureData()
    }
    
    
    // MARK: - initilaization
    fileprivate func configureUI() {
        if taskModel != nil {
            navigationItem.title = "Edit Task"
            saveEditButton.setTitle("Save", for: .normal)
            deleteButton.isHidden = false
        }
        else {
            navigationItem.title = "Add a Task"
            saveEditButton.setTitle("Create", for: .normal)
            deleteButton.isHidden = true
        }
        
        configureInitalData()
        
        categoryColorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(categoryColorPressed)))
        
        categoryTextField.delegate = self
        taskNameTextField.delegate = self
    }
    
    fileprivate func configureInitalData() {
        guard let taskModel = taskModel else { return }
        taskNameTextField.text = taskModel.title
        complitionDateTextField.text = getFormattedStringFrom(date: taskModel.completionDate)
        
        if let category = taskModel.category
        {
            if let categoryName = category.name, let categoryColor = SystemColors(rawValue: category.color ?? "")  {
                categoryTextField.text = categoryName
                categoryColorView.backgroundColor = categoryColor.uiColor
                selectedCategoryName = categoryName
                selectedCategoryColor = categoryColor
            }
        }
    }

    fileprivate func configureData() {
        categoriesArray = CoreDataManager.shared.fetchModels(entityType: CategoryModel.self)
    }

    
    // MARK: - actions
    @IBAction func selectDateButtonPressed(_ sender: Any) {
        view.endEditing(true)
        DatePickerViewController.showDatePicker { (date) in
            self.complitionDateTextField.text = self.getFormattedStringFrom(date: date)
        }
    }
    
    @IBAction func selectCategoryButtonPressed(_ sender: Any) {
        view.endEditing(true)
        
        let categoriesNames = categoriesArray.map { (model) -> String in
            return model.name ?? "-"
        }
        
        TypePickerViewController.ShowPickerWith(title: "Select Category", items: categoriesNames) { (index, value) in
            self.categoryTextField.text = value
            self.selectedCategoryName = value

            if let categoryColor = SystemColors(rawValue: self.categoriesArray[index].color ?? "") {
                self.categoryColorView.backgroundColor = categoryColor.uiColor
                self.selectedCategoryColor = categoryColor
            }
            
        }
    }
    
    @objc fileprivate func categoryColorPressed() {
        view.endEditing(true)
        showColorPicker { (pickedColor) in
            self.categoryColorView.backgroundColor = pickedColor.uiColor
            self.selectedCategoryColor = pickedColor
        }
    }

    @IBAction func deleteButtonPressed(_ sender: Any) {
        if let taskModel = taskModel {
            CoreDataManager.shared.deleteObject(taskModel) { (success) in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.showError(message: "An error occurred while deleting\nplease try again later")
                }
            }
        }
        
    }
    
    @IBAction func saveEditButtonPressed(_ sender: Any) {
        
        selectedCategoryName = categoryTextField.text
        
        if validate()
        {
            var taskModelToBeSaved: TaskModel!
            
            if let taskModel = taskModel {
                taskModelToBeSaved = taskModel
            }
            else {
                taskModelToBeSaved = TaskModel(context: CoreDataManager.shared.managedContext)
            }
            
            taskModelToBeSaved.title = taskNameTextField.text
            
            taskModelToBeSaved.category = selectedCategoryModel
            
            let fomratter = DateFormatter()
            fomratter.dateStyle = .medium
            taskModelToBeSaved.completionDate = fomratter.date(from: complitionDateTextField.text!)
            
            CoreDataManager.shared.saveContext { (success) in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.showError(message: "An error occurred while saving\nplease try again later")
                }
            }

        }

    }
    
    
    // MARK: - helper methods
    fileprivate func validate() -> Bool {
        if taskNameTextField.text == ""
        {
            showError(message: "Please fill in the task name")
            return false
        }
        return validateCategory()
    }
    
    fileprivate func validateCategory() -> Bool {
        let categories = CoreDataManager.shared.fetchModels(entityType: CategoryModel.self)
    
        for category in categories
        {
            if category.name?.lowercased() == selectedCategoryName?.lowercased() && category.color != selectedCategoryColor.rawValue
            {
                showError(message: "A category with this name exist\nPlease change category name or select a category from the list")
                return false
            }
            else if category.name?.lowercased() == selectedCategoryName?.lowercased() && category.color == selectedCategoryColor.rawValue {
                selectedCategoryModel = category
            }
        }
        
        if selectedCategoryModel == nil {
            selectedCategoryModel = CategoryModel(context: CoreDataManager.shared.managedContext)
            selectedCategoryModel?.name = selectedCategoryName
            selectedCategoryModel?.color = selectedCategoryColor.rawValue
        }
        
        return true
    }
    
    fileprivate func getFormattedStringFrom(date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    
}

// MARK: - UITextFieldDelegate
extension TaskAddUpdateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
