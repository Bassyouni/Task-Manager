//
//  RoundedShadowView.swift
//  Task Manager
//
//  Created by Bassyouni on 5/24/19.
//  Copyright © 2019 Bassyouni. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedShadowView: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    @IBInspectable var cornerRadius: CGFloat = 30.0
        {
        didSet
        {
            setupView()
        }
    }
    
    @IBInspectable var isPillShaped: Bool = false
        {
        didSet
        {
            setupView()
        }
    }
    
    @IBInspectable var hasShadow: Bool = true
        {
        didSet
        {
            setupView()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView()
    {
        if isPillShaped {
            layer.cornerRadius = frame.height / 2
        }
        else
        {
            layer.cornerRadius = cornerRadius
        }
        
        layer.shadowColor =  UIColor.lightGray.cgColor
        layer.shadowOpacity = hasShadow ? 0.8 : 0.0
        layer.shadowRadius = hasShadow ? 5.0 : 0
        layer.shadowOffset = CGSize(width: hasShadow ? 1.0 : 0.0, height: hasShadow ? 1.0 : -3.0)
    }
    
}



