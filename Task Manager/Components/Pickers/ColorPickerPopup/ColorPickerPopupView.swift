//
//  ColorPickerPopupView.swift
//  Task Manager
//
//  Created by Bassyouni on 5/24/19.
//  Copyright © 2019 Bassyouni. All rights reserved.
//

import UIKit

class ColorPickerPopupView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var popupContainerView: RoundedShadowView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    
    // MARK: - variables
    fileprivate var effect: UIVisualEffect!
    var didPickColorComplition: ((_ pickedColor: SystemColors) -> Void)?
    
    
    // MARK: - static variables
    static var viewIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - cell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    deinit {
        print("deinit: \(String(describing: self))")
    }
    
    
    // MARK: - initialization
    fileprivate func configureUI() {
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        configureCollectionView()
    }
    
    fileprivate func configureCollectionView() {
        collectionView.register(UINib(nibName: ColorCollectionViewCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ColorCollectionViewCell.cellIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    

    // MARK: - actions
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismissPopup()
    }
    
    @IBAction func wholeScreenDimissButtonPressed(_ sender: Any) {
        dismissPopup()
    }
    
    
    // MARK: - helpers
    fileprivate func animateIn() {
        
        popupContainerView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popupContainerView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.popupContainerView.alpha = 1
            self.popupContainerView.transform = CGAffineTransform.identity
        }
    }
    
    fileprivate func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.popupContainerView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.popupContainerView.alpha = 0
            self.visualEffectView.effect = nil
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    
    // MARK: - public methods
    @objc func dismissPopup() {
        animateOut()
    }
    
    func presentPopupView() {
        animateIn()
    }
    
}


// MARK: - collectionView
extension ColorPickerPopupView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SystemColors.allSystemColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.cellIdentifier, for: indexPath) as? ColorCollectionViewCell
        {
            cell.systemColor = SystemColors.allSystemColors[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let didPickColorComplition = didPickColorComplition {
            didPickColorComplition(SystemColors.allSystemColors[indexPath.row])
        }
        dismissPopup()
    }
    
}

