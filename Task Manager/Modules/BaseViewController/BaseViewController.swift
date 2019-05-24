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
}
