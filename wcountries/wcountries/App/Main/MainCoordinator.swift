//
//  MainCoordinator.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 26/02/21.
//

import Foundation

class MainCoordinator: Coordinator {
    var navigationController: SwipeBackNavigationController
    var childCoordinators = [Coordinator]()
    
    var filterByLanguage: ((_ iso639_2: String)->Void)? = nil
    var cleanLanguageFilter: (()->Void)? = nil
    
    init(navigationController: SwipeBackNavigationController){
        self.navigationController = navigationController
    }
    
    func start(){
        let vc = MainViewController()
        vc.config(viewModel: MainViewModel(self, manager: MainManager()))
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func startDetail(model: MainCountryModel){
        let detailCoordinator = DetailCoordinator(self, navigationController: navigationController, model: model)
        addCoordinator(detailCoordinator)
        detailCoordinator.start()
    }
    
    func startFilter(selectedIso639_2: String? = nil){
        let langFilterCoordinator = LangFilterCoordinator(self, navigationController: navigationController, selectedIso639_2: selectedIso639_2)
        addCoordinator(langFilterCoordinator)
        langFilterCoordinator.start()
    }
}

// MARK: - DetailCoordinatorDelegate
extension MainCoordinator: DetailCoordinatorDelegate {
    func onClose(_ coordinator: DetailCoordinator) {
        removeCoordinator(coordinator)
    }
}

// MARK: - LangFilterCoordinatorDelegate
extension MainCoordinator: LangFilterCoordinatorDelegate {
    func onClose(_ coordinator: LangFilterCoordinator) {
        removeCoordinator(coordinator)
    }
    
    func onLanguageSelected(iso639_2: String) {
        self.filterByLanguage?(iso639_2)
    }
    
    func onLanguageDeselected() {
        self.cleanLanguageFilter?()
    }
}
