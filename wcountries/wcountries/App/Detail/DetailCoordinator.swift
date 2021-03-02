//
//  DetailCoordinator.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 28/02/21.
//

import Foundation

class DetailCoordinator {
    private var navigationController: SwipeBackNavigationController
    
    init(navigationController: SwipeBackNavigationController){
        self.navigationController = navigationController
    }
    
    func start(model: MainCountryModel){
        let viewController = DetailViewController()
        let countryModel = CountryModel(name: model.name, alpha2Code: model.alpha2Code, alpha3Code: model.alpha3Code)
        viewController.config(viewModel: DetailViewModel(self, manager: DetailManager(), model: countryModel))
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension DetailCoordinator: DetailViewModelDelegate {
    func onBackDidTap() {
        navigationController.popViewController(animated: true)
    }
}
