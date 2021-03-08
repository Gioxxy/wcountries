//
//  LangFilterViewModel.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 06/03/21.
//

import Foundation

protocol LangFilterViewModelDelegate: class {
    func onLanguageSelected(iso639_2: String)
    func onLanguageDeselected()
}

class LangFilterViewModel {
    private weak var delegate: LangFilterViewModelDelegate?
    private var manager: LangFilterManager
    private var model = [LangFilterModel]()
    
    private var lastSelectedLanguageIso639_2: String?
    
    var languages = [LanguageViewModel]()
    
    var selectedLanguages: [LanguageViewModel] {
        return self.languages.filter({ $0.isSelected })
    }
    
    var unselectedLanguages: [LanguageViewModel] {
        return self.languages.filter({ !$0.isSelected })
    }
    
    init(_ delegate: LangFilterViewModelDelegate? = nil, manager: LangFilterManager, selectedIso639_2: String? = nil) {
        self.delegate = delegate
        self.manager = manager
        self.lastSelectedLanguageIso639_2 = selectedIso639_2
    }
    
    func getLanguages(onStart: (()->Void)? = nil, onCompletion: (()->Void)? = nil, onSuccess: ((LangFilterViewModel)->Void)? = nil, onError: ((String)->Void)? = nil){
        onStart?()
        manager.getLanguages(
            onSuccess: { [weak self] model in
                guard let `self` = self else { return }
                self.model = model
                self.languages = model.flatMap({ $0.languages }).unique(map: { $0.iso639_2 }).map({ model in
                    let isSelected = model.iso639_2 == self.lastSelectedLanguageIso639_2 || self.languages.first(where: {$0.iso639_2 == model.iso639_2 })?.isSelected ?? false
                    return LanguageViewModel(iso639_2: model.iso639_2 ?? "", name: model.name, isSelected: isSelected)
                })
                self.languages.sort(by: { $0.name < $1.name })
                onCompletion?()
                onSuccess?(self)
            },
            onError: { error in
                onCompletion?()
                onError?(error)
            }
        )
    }
    
    func onLanguageSelected(viewModel: LangFilterViewModel.LanguageViewModel){
        self.languages.first(where: { $0.isSelected })?.isSelected = false
        viewModel.isSelected = true
//        delegate?.onLanguageSelected(iso639_2: viewModel.iso639_2)
    }
    
    func onLanguageDeselected(viewModel: LangFilterViewModel.LanguageViewModel){
        viewModel.isSelected = false
//        delegate?.onLanguageDeselected()
    }
    
    func onClose(){
        if let selectedLang = selectedLanguages.first {
            delegate?.onLanguageSelected(iso639_2: selectedLang.iso639_2)
        } else {
            delegate?.onLanguageDeselected()
        }
    }
}

extension LangFilterViewModel {
    class LanguageViewModel {
        let iso639_2: String
        let name: String
        var isSelected: Bool
        
        init(iso639_2: String, name: String, isSelected: Bool = false) {
            self.iso639_2 = iso639_2
            self.name = name
            self.isSelected = isSelected
        }
    }
}
