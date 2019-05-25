//
//  SettingsViewController.swift
//  Task Manager
//
//  Created by Bassyouni on 5/25/19.
//  Copyright © 2019 Bassyouni. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var enableNotificationsTitleLabel: UILabel!
    @IBOutlet weak var enableNotifcationSwitch: UISwitch!
    @IBOutlet weak var categoryTextField: RoundedTextField!
    @IBOutlet weak var categoryColorView: RoundedShadowView!
    @IBOutlet weak var addCategoryButton: RoundedShadowButton!
    
    
    // MARK: - static methods
    static func instantiateFromStoryboard() -> SettingsViewController {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! SettingsViewController
    }
    
    
    // MARK: - variables
    private var selectedCategoryColor: SystemColors = .orange
    private var categoriesArray = [CategoryModel]()
    
    
    
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureData()
    }
    
    
    // MARK: - initilaization
    func configureUI() {
        categoryColorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(categoryColorPressed)))
        categoryTextField.delegate = self
        
        navigationItem.title = "Settings"
    }
    
    func configureData() {
        categoriesArray = CoreDataManager.shared.fetchModels(entityType: CategoryModel.self)
    }

    
    // MARK: - actions
    @IBAction func enableNotificationsValueChanged(_ sender: Any) {
        if !enableNotifcationSwitch.isOn {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
    
    @IBAction func addCategoryButtonPressed(_ sender: Any) {
        if validateCategory() {
            let category = CategoryModel(context: CoreDataManager.shared.managedContext)
            category.name = categoryTextField.text
            category.color = selectedCategoryColor.rawValue
            
            CoreDataManager.shared.saveContext { (success) in
                if success
                {
                   self.showSuccessMessage(message: "New Category Saved Successfully", complition: {
                        self.categoryTextField.text = ""
                    })
                }
                else
                {
                    self.showError(message: "An error occurred while saving\nplease try again later")
                }
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
    
    // MARK: - helper methods
    fileprivate func validateCategory() -> Bool {
        
        guard let categoryName = categoryTextField.text, !categoryName.isEmpty else {
            return false
        }
        
        for category in categoriesArray
        {
            if category.name?.lowercased() == categoryName.lowercased() && category.color != selectedCategoryColor.rawValue
            {
                showError(message: "A category with this name exist\nPlease change category name")
                return false
            }
            else if category.name?.lowercased() == categoryName.lowercased() && category.color == selectedCategoryColor.rawValue {
                showError(message: "An exact category with this data exist\nPlease change category name")
                return false
            }
        }
        return true
    }

    
    
}

// MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
