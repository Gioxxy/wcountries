//
//  LangFilterCoordinator.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 06/03/21.
//

import Foundation

protocol LangFilterCoordinatorDelegate: class {
    func onClose(_ coordinator: LangFilterCoordinator)
    func onLanguageSelected(iso639_2: String)
    func onLanguageDeselected()
}

class LangFilterCoordinator {
    private weak var delegate: LangFilterCoordinatorDelegate?
    private var navigationController: SwipeBackNavigationController
    
    init(_ delegate: LangFilterCoordinatorDelegate? = nil, navigationController: SwipeBackNavigationController){
        self.delegate = delegate
        self.navigationController = navigationController
    }
    
    func start(selectedIso639_2: String? = nil){
        let vc = LangFilterViewController()
        vc.config(viewModel: LangFilterViewModel(self, manager: LangFilterManager(), selectedIso639_2: selectedIso639_2))
        self.navigationController.present(vc, animated: true)
    }
    
    deinit {
        print(String(describing: self) + " deinit")
    }
}

// MARK: - LangFilterViewModelDelegate
extension LangFilterCoordinator: LangFilterViewModelDelegate {
    func onClose(){
        delegate?.onClose(self)
    }
    
    func onLanguageSelected(iso639_2: String) {
        delegate?.onLanguageSelected(iso639_2: iso639_2)
    }
    
    func onLanguageDeselected() {
        delegate?.onLanguageDeselected()
    }
}
