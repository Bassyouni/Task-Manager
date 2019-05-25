//
//  DatePickerViewController.swift
//  TawkeelPRO
//
//  Created by Bassyouni on 5/24/19.
//  Copyright © 2019 Bassyouni. All rights reserved.
//

import UIKit

@objc protocol DatePickerViewControllerDelegate: class {
    func didSelectDate(date: Date)
}

class DatePickerViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var okBtn: RoundedShadowView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var pickerTitleLabel: UILabel!
    @IBOutlet weak var pickerBottomSpaceConstraint: NSLayoutConstraint!
    
    
    // MARK: - variables
    var pickerTitle: String = "Select Date"
    
    weak var delegate: DatePickerViewControllerDelegate?
    var datePickerComplition: ( (Date) -> () )?
    
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        }
    }

    
    // MARK: - static functions
    static func instantiateFromStoryboard() -> DatePickerViewController {
        let storyboard = UIStoryboard(name: "Picker", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
    }
    
    static func showDatePicker(complition: @escaping (Date) -> () ) {
        let viewController = DatePickerViewController.instantiateFromStoryboard()
        viewController.datePickerComplition = complition
        UIApplication.shared.keyWindow?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    

    // MARK: - methods
    fileprivate func configureUI() {
        pickerTitleLabel.text = pickerTitle
        backGroundView.backgroundColor = .white
        let image = UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate)
        closeBtn.setImage(image, for: .normal)
        closeBtn.alpha = 1
    }
    
    // MARK: - IBActions
    @IBAction func okBtnPressed(_ sender: Any) {
        
//        if datePickerView.date < Date() {
//            showError(message: "You cannot select a complition date in the past")
//            return
//        }
        
        if let complitionClosure = datePickerComplition {
            complitionClosure(datePickerView.date)
        }
        self.delegate?.didSelectDate(date: datePickerView.date)
        
        dismissPicker()
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismissPicker()
    }
    
    @IBAction func backgroundButtonPressed(_ sender: Any) {
        dismissPicker()
    }
    
    // MARK: - helpers
    fileprivate func dismissPicker() {
        pickerBottomSpaceConstraint.constant = 300
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.backgroundColor = .clear
            self.view.layoutIfNeeded()
        }) { (_) in
            self.dismiss(animated: false, completion: nil)
        }

    }
    
}


