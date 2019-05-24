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
    
    
    // MARK: - variables
    var taskModel: AnyObject?
    
    
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
        }
        else {
            navigationItem.title = "Add a Task"
            saveEditButton.setTitle("Create", for: .normal)
        }
        
        categoryColorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(categoryColorPressed)))
        
        categoryTextField.delegate = self
        taskNameTextField.delegate = self
    }
    
    fileprivate func configureData() {
        
    }

    
    // MARK: - actions
    @IBAction func selectDateButtonPressed(_ sender: Any) {
        view.endEditing(true)
        DatePickerViewController.showDatePicker { (date) in
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            self.complitionDateTextField.text = formatter.string(from: date)
        }
    }
    
    @IBAction func selectCategoryButtonPressed(_ sender: Any) {
        view.endEditing(true)
        TypePickerViewController.ShowPickerWith(title: "Select Category", items: ["Save", "Medic"]) { (index, value) in
            self.categoryTextField.text = value
        }
    }
    
    @objc fileprivate func categoryColorPressed() {
        showColorPicker { (pickedColor) in
            self.categoryColorView.backgroundColor = pickedColor.uiColor
        }
    }
    
    
    // MARK: - helper methods
    
    
}

extension TaskAddUpdateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
