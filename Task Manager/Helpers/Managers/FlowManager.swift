//
//  FlowManager.swift
//  Lagorta
//
//  Created by Bassyouni on 5/24/19.
//  Copyright © 2019 Bassyouni. All rights reserved.
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
    
    private func switchToMainModeController() {
        let tasksListHomeViewController = TasksListHomeViewController.instantiateFromStoryboard()
        let navigationController = UINavigationController(rootViewController: tasksListHomeViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        setRootViewController(viewController: navigationController)
    }
    
    
    private func setRootViewController(viewController:UIViewController) {
        self.window?.rootViewController = viewController
    }
    
}
