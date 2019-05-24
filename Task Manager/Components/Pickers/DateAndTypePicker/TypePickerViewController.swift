//
//  TypePickerViewController.swift
//  TawkeelPRO
//
//  Created by Bassyouni on 5/24/19.
//  Copyright © 2019 Bassyouni. All rights reserved.
//

import UIKit

@objc protocol TypePickerViewControllerDelegate: class {
    func didSelectItem(index:Int,item: String)
}

class TypePickerViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var okBtn: RoundedShadowView!
    @IBOutlet weak var typePickerView: UIPickerView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var pickerTitleLabel: UILabel!
    @IBOutlet weak var pickerBottomSpaceConstraint: NSLayoutConstraint!
    
    // MARK: - variables
    var items: [String] = [String](){
        didSet{
            if items.count > 0{
                selectedItem = items[0]
            }
        }
    }
    
    var pickerTitle:String = ""
    var selectedItem: String = ""
    var selectedIndex: Int = 0{
        didSet{
            if items.count > selectedIndex{
                selectedItem = items[selectedIndex]
            }
        }
    }
    
    weak var delegate: TypePickerViewControllerDelegate?
    var typePickerComplition: ( (Int,String) -> () )?
    
    
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
    static func instantiateFromStoryboard() -> TypePickerViewController {
        let storyboard = UIStoryboard(name: "Picker", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "TypePickerViewController") as! TypePickerViewController
    }
    
    static func ShowPickerWith(title:String,items: [String], selectedIndex:Int = 0, complition: @escaping (Int,String) -> ()) {
        let viewController = TypePickerViewController.instantiateFromStoryboard()
        viewController.pickerTitle = title
        viewController.items = items
        viewController.selectedIndex = selectedIndex
        viewController.typePickerComplition = complition
        UIApplication.shared.keyWindow?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    
    // MARK: - methods
    fileprivate func configureUI() {
        pickerTitleLabel.text = pickerTitle
        backGroundView.backgroundColor = .white
        let image = UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate)
        closeBtn.setImage(image, for: .normal)
        closeBtn.alpha = 1
        typePickerView.delegate = self
        typePickerView.dataSource = self
        typePickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
    }
    
    
    // MARK: - IBActions
    @IBAction func okBtnPressed(_ sender: Any) {
        
        if let complitionClosure = typePickerComplition {
            complitionClosure(selectedIndex,selectedItem)
        }
        self.delegate?.didSelectItem(index:selectedIndex, item: selectedItem)
        
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

extension TypePickerViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
    }
}

extension TypePickerViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45
    }
}

