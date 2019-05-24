//
//  TaskTableViewCell.swift
//  Task Manager
//
//  Created by Bassyouni on 5/24/19.
//  Copyright © 2019 Bassyouni. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    // MARK: - IBoutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var completionDateLabel: UILabel!
    @IBOutlet weak var titleValueLabel: UILabel!
    @IBOutlet weak var completionDateValueLabel: UILabel!
    @IBOutlet weak var categoryColorView: RoundedShadowView!
    @IBOutlet weak var taskNameContainerView: UIView!
    @IBOutlet weak var complitionDateContainerView: UIView!
    
    // MARK: - variables
    var taskModel: AnyObject! {
        didSet { bindUI() }
    }
    
    
    // MARK: - cell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    
    // MARK: - initialization
    fileprivate func configureUI() {
        selectionStyle = .none
    }
    
    
    fileprivate func bindUI() {
        
    }
    
}
