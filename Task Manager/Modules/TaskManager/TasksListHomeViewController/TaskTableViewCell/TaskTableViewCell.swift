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
    @IBOutlet weak var categoryContainerView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    
    // MARK: - cell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    
    // MARK: - initialization
    fileprivate func configureUI() {
        selectionStyle = .none
    }
    
    
    func bindUI(taskModel: TaskModel, isCompleted: Bool) {
        titleValueLabel.text = taskModel.title
        
        if let completionDate = taskModel.completionDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            completionDateValueLabel.text = formatter.string(from: completionDate)
            complitionDateContainerView.isHidden = false
        }
        else {
            complitionDateContainerView.isHidden = true
        }
        
        if let categorModel = taskModel.category, let categoryColor = SystemColors(rawValue: categorModel.color ?? "")
        {
            categoryColorView.backgroundColor = categoryColor.uiColor
            categoryContainerView.isHidden = false
        }
        else
        {
            categoryContainerView.isHidden = true
        }
        
        if isCompleted
        {
            statusImageView.image = #imageLiteral(resourceName: "tickIcon")
        }
        else
        {
            statusImageView.image = #imageLiteral(resourceName: "pendingIcon")
        }
        
    }
    
}
