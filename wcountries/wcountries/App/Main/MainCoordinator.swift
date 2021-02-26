//
//  MainCoordinator.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 26/02/21.
//

import Foundation

class MainCoordinator {
    private var navigationController: SwipeBackNavigationController
    
    init(navigationController: SwipeBackNavigationController){
        self.navigationController = navigationController
    }
    
    func start(){
        let vc = MainViewController()
        vc.config()
        self.navigationController.pushViewController(vc, animated: true)
    }
    
}
