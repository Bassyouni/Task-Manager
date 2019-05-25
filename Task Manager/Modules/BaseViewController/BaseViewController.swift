//
//  BaseViewController.swift
//  Task Manager
//
//  Created by Bassyouni on 5/24/19.
//  Copyright © 2019 Bassyouni. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("deinit: \(String(describing: self))")
    }
    
    
    // MARK: - helper methods
    func showColorPicker(complition: ((_ pickedColor: SystemColors) -> Void)?) {
        if let colorPickerView = Bundle.main.loadNibNamed(ColorPickerPopupView.viewIdentifier, owner: self, options: nil)?.last as? ColorPickerPopupView
        {
            view.addSubview(colorPickerView)
            colorPickerView.fillSuperview()
            colorPickerView.didPickColorComplition = complition
            colorPickerView.presentPopupView()
        }
    }
    
    func showError(message: String, complition: (() -> ())? = nil) {
        showAlert(withTitle: "Error", message: message, complition: complition)
    }
    
    func showSuccessMessage(message: String, complition: (() -> ())? = nil) {
        showAlert(withTitle: "Success", message: message,complition: complition)
    }
    
    fileprivate func showAlert(withTitle title: String, message: String, complition: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { (_) in
            if let complition = complition {
                complition()
            }
        }
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
