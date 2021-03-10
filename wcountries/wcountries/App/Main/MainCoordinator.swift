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
    private var langFilterCoordinator: LangFilterCoordinator?
    
    var filterByLanguage: ((_ iso639_2: String)->Void)? = nil
    var cleanLanguageFilter: (()->Void)? = nil
    
    init(navigationController: SwipeBackNavigationController){
        self.navigationController = navigationController
    }
    
    func start(){
        let model = [MainCountryModel]()
        let vc = MainViewController()
        vc.config(viewModel: MainViewModel(self, manager: MainManager(), model: model))
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func startDetail(model: MainCountryModel){
        detailCoordinator = DetailCoordinator(self, navigationController: navigationController)
        detailCoordinator?.start(model: model)
    }
    
    func startFilter(selectedIso639_2: String? = nil){
        langFilterCoordinator = LangFilterCoordinator(self, navigationController: navigationController)
        langFilterCoordinator?.start(selectedIso639_2: selectedIso639_2)
    }
}

extension MainCoordinator: DetailCoordinatorDelegate {
    func onClose(_ coordinator: DetailCoordinator) {
        detailCoordinator = nil
    }
}

extension MainCoordinator: LangFilterCoordinatorDelegate {
    func onClose(_ coordinator: LangFilterCoordinator) {
        langFilterCoordinator = nil
    }
    
    func onLanguageSelected(iso639_2: String) {
        self.filterByLanguage?(iso639_2)
    }
    
    func onLanguageDeselected() {
        self.cleanLanguageFilter?()
    }
}
