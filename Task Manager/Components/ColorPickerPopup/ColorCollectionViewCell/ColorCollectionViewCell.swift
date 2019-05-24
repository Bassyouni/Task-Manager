//
//  ColorCollectionViewCell.swift
//  Task Manager
//
//  Created by Bassyouni on 5/24/19.
//  Copyright © 2019 Bassyouni. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var colorView: UIView!
    
    
    // MARK: - variables
    var systemColor: SystemColors! {
        didSet { bindUI() }
    }
    
    
    // MARK: - cell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    
    // MARK: - initialization
    fileprivate func configureUI() {
        colorView.layer.cornerRadius = 10
    }
    
    fileprivate func bindUI() {
        colorView.backgroundColor = systemColor.uiColor
    }

}
