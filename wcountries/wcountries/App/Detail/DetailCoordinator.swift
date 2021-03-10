//
//  DetailCoordinator.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 28/02/21.
//

import Foundation

protocol DetailCoordinatorDelegate: class {
    func onClose(_ coordinator: DetailCoordinator)
}

class DetailCoordinator {
    private weak var delegate: DetailCoordinatorDelegate?
    private var navigationController: SwipeBackNavigationController
    
    init(_ delegate: DetailCoordinatorDelegate? = nil, navigationController: SwipeBackNavigationController){
        self.delegate = delegate
        self.navigationController = navigationController
    }
    
    func start(model: MainCountryModel){
        let viewController = DetailViewController()
        let countryModel = CountryModel(name: model.name, alpha2Code: model.alpha2Code, alpha3Code: model.alpha3Code)
        viewController.config(viewModel: DetailViewModel(self, manager: DetailManager(), model: countryModel))
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    deinit {
        print(String(describing: self) + " deinit")
    }
}

extension DetailCoordinator: DetailViewModelDelegate {
    func onBackDidTap() {
        navigationController.popViewController(animated: true)
    }
    
    func onClose(){
        delegate?.onClose(self)
    }
}
