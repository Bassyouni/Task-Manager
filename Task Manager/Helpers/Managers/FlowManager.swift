//
//  FlowManager.swift
//  Lagorta
//
//  Created by Mohamad Tarek on 19/4/19.
//  Copyright © 2019 Mohamed Abd el-latef. All rights reserved.
//

import UIKit

class FlowManager {
    
    static let shared = FlowManager()
    var window: UIWindow?
    
    init() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
    }
    
    func activateMainFlow() {
        switchToMainModeController()
    }
    
    func makeWindowKeyAndVisible() {
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Private
    func switchToMainModeController() {
        let tasksListHomeViewController = TasksListHomeViewController.instantiateFromStoryboard()
        setRootViewController(viewController: tasksListHomeViewController)
    }
    
    
    func setRootViewController(viewController:UIViewController) {
        self.window?.rootViewController = viewController
    }
    
}
