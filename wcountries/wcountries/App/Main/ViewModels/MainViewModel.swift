//
//  MainViewModel.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 27/02/21.
//

import Foundation

protocol MainViewModelDelegate: class {
    func startDetail(model: MainCountryModel)
}

class MainViewModel {
    private weak var delegate: MainViewModelDelegate?
    private var manager: MainManager
    private var model: [MainCountryModel]
    
    var regions: [RegionViewModel]
    var countries: [CountryViewModel]
    
    init(_ delegate: MainViewModelDelegate, manager: MainManager, model: [MainCountryModel]) {
        self.delegate = delegate
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
    
    func getContinentCountries(continent: MainViewModel.RegionViewModel, onSuccess: ((MainViewModel)->Void)? = nil, onError: ((String)->Void)? = nil){
        manager.getContinentCountries(
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
    
    func didTapOnCountry(viewModel: CountryViewModel){
        if let model = model.first(where: { $0.alpha2Code == viewModel.alpha2Code}) {
            delegate?.startDetail(model: model)
        }
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
