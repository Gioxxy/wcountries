//
//  MainCoordinator.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 26/02/21.
//

import Foundation

class MainCoordinator {
    private var navigationController: SwipeBackNavigationController
    private var detailCoordinator: DetailCoordinator?
    
    init(navigationController: SwipeBackNavigationController){
        self.navigationController = navigationController
    }
    
    func start(){
        let vc = MainViewController()
        let model: [MainCountryModel] = []
        vc.config(viewModel: MainViewModel(self, manager: MainManager(), model: model))
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension MainCoordinator: MainViewModelDelegate {
    func startDetail(model: MainCountryModel){
        print("Detail starting")
        detailCoordinator = DetailCoordinator(navigationController: navigationController)
        detailCoordinator?.start(model: model)
    }
}
