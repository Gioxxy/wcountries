//
//  MainCoordinator.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 26/02/21.
//

import Foundation

class MainCoordinator {
    private var navigationController: SwipeBackNavigationController
    private var manager: MainManager = MainManager()
    
    init(navigationController: SwipeBackNavigationController){
        self.navigationController = navigationController
    }
    
    func start(){
        let vc = MainViewController()
        let model: [CountryModel] = [] //TODO: Add request
        vc.config(self, viewModel: MainViewModel(model: model))
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    //MARK: - MainViewController
    func getCountries(onSuccess: ((_ mainModel: MainViewModel)->Void)? = nil, onError: ((String)->Void)? = nil){
        manager.getCountries(
            onSuccess: { model in
                onSuccess?(MainViewModel(model: model))
            },
            onError: onError
        )
    }
}
