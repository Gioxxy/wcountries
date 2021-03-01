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
    
    func start(model: CountryModel){
        let viewController = DetailViewController()
        viewController.config(viewModel: DetailViewModel(self, model: model))
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension DetailCoordinator: DetailViewModelDelegate {
    func onBackDidTap() {
        navigationController.popViewController(animated: true)
    }
}
