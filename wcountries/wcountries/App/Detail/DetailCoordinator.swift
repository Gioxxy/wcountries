//
//  DetailCoordinator.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 28/02/21.
//

import UIKit

protocol DetailCoordinatorDelegate: class {
    func onClose(_ coordinator: DetailCoordinator)
}

class DetailCoordinator: Coordinator, DetailCoordinatorDelegate {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    private weak var delegate: DetailCoordinatorDelegate?
    private var model: MainCountryModel
    
    init(_ delegate: DetailCoordinatorDelegate? = nil, navigationController: UINavigationController, model: MainCountryModel){
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
    
    func onClose(_ coordinator: DetailCoordinator) {
        removeCoordinator(coordinator)
    }
}

// MARK: - DetailViewModelDelegate
extension DetailCoordinator: DetailViewModelDelegate {
    func onBackDidTap() {
        navigationController.popViewController(animated: true)
        delegate?.onClose(self)
    }
    
    func onPopGesture(){
        delegate?.onClose(self)
    }
    
    func startDetail(model: MainCountryModel) {
        let detailCoordinator = DetailCoordinator(self, navigationController: self.navigationController, model: model)
        addCoordinator(detailCoordinator)
        detailCoordinator.start()
    }
}
