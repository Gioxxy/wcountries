//
//  MainViewModel.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 27/02/21.
//

import Foundation

class MainViewModel {
    private weak var coordinator: MainCoordinator?
    private var manager: MainManager
    private var model: [MainCountryModel]
    
    var regions: [RegionViewModel]
    var countries: [CountryViewModel]
    
    var selectedIso639_2: String? = nil
    
    var updateGridView: (()->Void)? = nil
    
    init(_ coordinator: MainCoordinator? = nil, manager: MainManager, model: [MainCountryModel]) {
        self.coordinator = coordinator
        self.manager = manager
        self.model = model
        self.regions = [
            RegionViewModel(.Africa),
            RegionViewModel(.Americas),
            RegionViewModel(.Asia),
            RegionViewModel(.Europe),
            RegionViewModel(.Oceania)
        ]
        
        self.countries = model.map({ CountryViewModel(name: $0.name, alpha2Code: $0.alpha2Code) })
        
        self.coordinator?.filterByLanguage = { [weak self] iso639_2 in
            guard let `self` = self else { return }
            
            self.selectedIso639_2 = iso639_2
            self.manager.getCountriesBy(
                iso639_2: iso639_2,
                onSuccess: { [weak self] model in
                    guard let `self` = self else { return }
                    self.model = model
                    self.countries = model.map({ CountryViewModel(name: $0.name, alpha2Code: $0.alpha2Code) })
                    self.updateGridView?()
                },
                onError: { error in
                    // TODO: Show error
                }
            )
            self.updateGridView?()
        }
        
        self.coordinator?.cleanLanguageFilter = { [weak self] in
            guard let `self` = self else { return }
            
            self.selectedIso639_2 = nil
            manager.getCountries(
                onSuccess: { [weak self] model in
                    guard let `self` = self else { return }
                    self.model = model
                    self.countries = model.map({ CountryViewModel(name: $0.name, alpha2Code: $0.alpha2Code) })
                    self.updateGridView?()
                },
                onError: { error in
                    // TODO: Show error
                }
            )
        }
    }
    
    func getCountries(onSuccess: ((MainViewModel)->Void)? = nil, onError: ((String)->Void)? = nil){
        manager.getCountries(
            onSuccess: { [weak self] model in
                guard let `self` = self else { return }
                self.model = model
                self.countries = model.map({ CountryViewModel(name: $0.name, alpha2Code: $0.alpha2Code) })
                onSuccess?(self)
            },
            onError: onError
        )
    }
    
    func didSelectContinent(continent: MainViewModel.RegionViewModel, onSuccess: ((MainViewModel)->Void)? = nil, onError: ((String)->Void)? = nil){
        manager.getCountriesBy(
            continent: continent,
            onSuccess: { [weak self] model in
                guard let `self` = self else { return }
                self.model = model
                self.countries = model.map({ CountryViewModel(name: $0.name, alpha2Code: $0.alpha2Code) })
                onSuccess?(self)
            },
            onError: onError
        )
    }
    
    func didDeselectContinent(onSuccess: ((MainViewModel)->Void)? = nil, onError: ((String)->Void)? = nil) {
        manager.getCountries(
            onSuccess: { [weak self] model in
                guard let `self` = self else { return }
                self.model = model
                self.countries = model.map({ CountryViewModel(name: $0.name, alpha2Code: $0.alpha2Code) })
                onSuccess?(self)
            },
            onError: onError
        )
    }
    
    func didTapOnCountry(viewModel: CountryViewModel){
        if let model = model.first(where: { $0.alpha2Code == viewModel.alpha2Code}) {
            coordinator?.startDetail(model: model)
        }
    }
    
    func didTapOnFilterButton(){
        coordinator?.startFilter(selectedIso639_2: selectedIso639_2)
    }
}

extension MainViewModel {
    class RegionViewModel {
        let type: RegionType
        let imageName: String?
        var isSelected: Bool
        
        init(_ type: RegionType, isSelected: Bool = false) {
            self.type = type
            self.isSelected = isSelected
            switch type {
            case .Africa:
                self.imageName = "africa"
            case .Americas:
                self.imageName = "americas"
            case .Asia:
                self.imageName = "asia"
            case .Europe:
                self.imageName = "europe"
            case .Oceania:
                self.imageName = "oceania"
            case .Polar:
                self.imageName = nil
            case .Unknow:
                self.imageName = nil
            }
        }
    }
    
    class CountryViewModel {
        let name: String
        let alpha2Code: String
        let imageURL: URL?
        
        init(name: String, alpha2Code: String) {
            self.name = name.uppercased()
            self.alpha2Code = alpha2Code
            self.imageURL = URL(string: "https://flagcdn.com/h60/\(alpha2Code.lowercased()).png")
        }
    }
}
