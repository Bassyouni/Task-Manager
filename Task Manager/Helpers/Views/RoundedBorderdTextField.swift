//
//  RoundedBorderdTextField.swift
//  Task Manager
//
//  Created by Bassyouni on 5/24/19.
//  Copyright © 2019 Bassyouni. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateView()
    }

    
    @IBInspectable var rightImage : UIImage? = nil {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var rightImageWidth : CGFloat = 0.0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightImagHeight : CGFloat = 0.0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.lightGray {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet{
            updateView()
        }
    }
    
    func updateView() {
        
        layer.cornerRadius = 2
        layer.borderWidth = borderWidth
        layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        if rightImage != nil
        {
            let rightImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: rightImageWidth,height : rightImagHeight))
            rightImageView.image = rightImage
            rightImageView.contentMode = .center
            let view = UIView(frame: CGRect(x: 0, y: 0, width: rightImageWidth + 20, height: self.frame.height))
            view.isUserInteractionEnabled = false
            rightImageView.center = view.center
            rightImageView.center.x = view.center.x
            view.addSubview(rightImageView)
            rightView = view
            rightViewMode = .always
        }
        else if rightImageWidth != 0
        {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: rightImageWidth, height: self.frame.height))
            rightView = view
            rightViewMode = .always
        }
        else
        {
            rightView = nil
        }
    }
    
    
}


