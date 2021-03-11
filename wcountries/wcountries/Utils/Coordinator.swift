//
//  Coordinator.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 11/03/21.
//

import Foundation

protocol Coordinator: class {
    var navigationController: SwipeBackNavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator{
    func removeCoordinator(_ childCoordinator: Coordinator){
        childCoordinators = childCoordinators.filter({ $0 !== childCoordinator })
    }
    func addCoordinator(_ childCoordinator: Coordinator){
        childCoordinators.append(childCoordinator)
    }
}
