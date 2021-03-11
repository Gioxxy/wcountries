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

class DetailCoordinator: Coordinator {
    var navigationController: SwipeBackNavigationController
    var childCoordinators = [Coordinator]()
    
    private weak var delegate: DetailCoordinatorDelegate?
    private var model: MainCountryModel
    
    init(_ delegate: DetailCoordinatorDelegate? = nil, navigationController: SwipeBackNavigationController, model: MainCountryModel){
        self.delegate = delegate
        self.navigationController = navigationController
        self.model = model
    }
    
    func start(){
        let viewController = DetailViewController()
        viewController.config(viewModel: DetailViewModel(self, manager: DetailManager(), model: model))
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    deinit {
        print(String(describing: self) + " deinit")
    }
}

// MARK: - DetailViewModelDelegate
extension DetailCoordinator: DetailViewModelDelegate {
    func onBackDidTap() {
        navigationController.popViewController(animated: true)
    }
    
    func onClose(){
        delegate?.onClose(self)
    }
}
