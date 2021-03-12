//
//  AppCoordinator.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 12/03/21.
//

import UIKit

final class AppCoordinator: Coordinator{
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    
    init(window: UIWindow){
        self.window = window
        navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
    }
    
    //Start the app from MainCoordinator and append it in the childCoordinatorsList
    func start() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        self.addCoordinator(mainCoordinator)
        mainCoordinator.start()
        
        // Override dark mode
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light
        }
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}
