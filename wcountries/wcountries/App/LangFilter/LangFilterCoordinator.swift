//
//  LangFilterCoordinator.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 06/03/21.
//

import UIKit

protocol LangFilterCoordinatorDelegate: class {
    func onClose(_ coordinator: LangFilterCoordinator)
    func onLanguageSelected(iso639_2: String)
    func onLanguageDeselected()
}

class LangFilterCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    private weak var delegate: LangFilterCoordinatorDelegate?
    private var selectedIso639_2: String?
    
    init(_ delegate: LangFilterCoordinatorDelegate? = nil, navigationController: UINavigationController, selectedIso639_2: String? = nil){
        self.delegate = delegate
        self.navigationController = navigationController
        self.selectedIso639_2 = selectedIso639_2
    }
    
    func start(){
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
