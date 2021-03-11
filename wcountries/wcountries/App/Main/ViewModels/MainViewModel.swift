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
    private var model = [MainCountryModel]()
    
    private(set) var regions: [RegionViewModel]
    private(set) var countries = [CountryViewModel]()
    
    private(set) var selectedIso639_2: String? = nil
    private(set) var selectedContinent: MainViewModel.RegionViewModel? = nil
    
    var updateGridView: (()->Void)? = nil
    var showError: ((String)->Void)? = nil
    var showLoader: (()->Void)? = nil
    var dismissLoader: (()->Void)? = nil
    
    deinit {
        print(String(describing: self) + " deinit")
    }
    
    init(_ coordinator: MainCoordinator? = nil, manager: MainManager) {
        self.coordinator = coordinator
        self.manager = manager
        self.regions = [
            RegionViewModel(.Africa),
            RegionViewModel(.Americas),
            RegionViewModel(.Asia),
            RegionViewModel(.Europe),
            RegionViewModel(.Oceania)
        ]
                
        self.coordinator?.filterByLanguage = { [weak self] iso639_2 in
            guard let self = self else { return }
            self.showLoader?()
            self.selectedIso639_2 = iso639_2
            self.manager.getCountriesBy(
                iso639_2: iso639_2,
                onSuccess: { [weak self] modelByLanguage in
                    guard let self = self else { return }
                    
                    if let selectedContinent = self.selectedContinent {
                        self.manager.getCountriesBy(
                            continent: selectedContinent,
                            onSuccess: { [weak self] modelByContinent in
                                guard let self = self else { return }
                                self.model = modelByLanguage.filter({ country in
                                    modelByContinent.contains(where: { $0.name == country.name })
                                })
                                self.countries = self.model.map({ CountryViewModel(name: $0.name, alpha2Code: $0.alpha2Code) })
                                self.dismissLoader?()
                                self.updateGridView?()
                            },
                            onError: { [weak self] error in
                                guard let self = self else { return }
                                self.dismissLoader?()
                                self.showError?(error)
                            }
                        )
                    } else {
                        self.model = modelByLanguage
                        self.countries = modelByLanguage.map({ CountryViewModel(name: $0.name, alpha2Code: $0.alpha2Code) })
                        self.dismissLoader?()
                        self.updateGridView?()
                    }
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    self.dismissLoader?()
                    self.showError?(error)
                }
            )
        }
        
        self.coordinator?.cleanLanguageFilter = { [weak self] in
            guard let self = self else { return }
            self.showLoader?()
            self.selectedIso639_2 = nil
            if let selectedContinent = self.selectedContinent {
                manager.getCountriesBy(
                    continent: selectedContinent,
                    onSuccess: { [weak self] model in
                        guard let self = self else { return }
                        self.model = model
                        self.countries = model.map({ CountryViewModel(name: $0.name, alpha2Code: $0.alpha2Code) })
                        self.dismissLoader?()
                        self.updateGridView?()
                    },
                    onError: { [weak self] error in
                        guard let self = self else { return }
                        self.dismissLoader?()
                        self.showError?(error)
                    }
                )
            } else {
                manager.getCountries(
                    onSuccess: { [weak self] model in
                        guard let self = self else { return }
                        self.model = model
                        self.countries = model.map({ CountryViewModel(name: $0.name, alpha2Code: $0.alpha2Code) })
                        self.dismissLoader?()
                        self.updateGridView?()
                    },
                    onError: { [weak self] error in
                        guard let self = self else { return }
                        self.dismissLoader?()
                        self.showError?(error)
                    }
                )
            }
        }
    }
    
    func getCountries(){
        self.showLoader?()
        manager.getCountries(
            onSuccess: { [weak self] model in
                guard let self = self else { return }
                self.model = model
                self.countries = model.map({ CountryViewModel(name: $0.name, alpha2Code: $0.alpha2Code) })
                self.dismissLoader?()
                self.updateGridView?()
            },
            onError: { [weak self] error in
                guard let self = self else { return }
                self.dismissLoader?()
                self.showError?(error)
            }
        )
    }
    
    func didSelectContinent(continent: MainViewModel.RegionViewModel){
        self.showLoader?()
        selectedContinent = continent
        manager.getCountriesBy(
            continent: continent,
            onSuccess: { [weak self] modelByContinent in
                guard let self = self else { return }
                if let selectedIso639_2 = self.selectedIso639_2 {
                    self.manager.getCountriesBy(
                        iso639_2: selectedIso639_2,
                        onSuccess: { [weak self] modelByLanguage in
                            guard let self = self else { return }
                            self.model = modelByContinent.filter({ country in
                                modelByLanguage.contains(where: { $0.name == country.name })
                            })
                            self.countries = self.model.map({ CountryViewModel(name: $0.name, alpha2Code: $0.alpha2Code) })
                            self.dismissLoader?()
                            self.updateGridView?()
                        },
                        onError: { [weak self] error in
                            guard let self = self else { return }
                            self.dismissLoader?()
                            self.showError?(error)
                        }
                    )
                } else {
                    self.model = modelByContinent
                    self.countries = modelByContinent.map({ CountryViewModel(name: $0.name, alpha2Code: $0.alpha2Code) })
                    self.dismissLoader?()
                    self.updateGridView?()
                }
            },
            onError: { [weak self] error in
                guard let self = self else { return }
                self.dismissLoader?()
                self.showError?(error)
            }
        )
    }
    
    func didDeselectContinent() {
        self.showLoader?()
        selectedContinent = nil
        if let selectedIso639_2 = self.selectedIso639_2 {
            manager.getCountriesBy(
                iso639_2: selectedIso639_2,
                onSuccess: { [weak self] model in
                    guard let self = self else { return }
                    self.model = model
                    self.countries = model.map({ CountryViewModel(name: $0.name, alpha2Code: $0.alpha2Code) })
                    self.dismissLoader?()
                    self.updateGridView?()
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    self.dismissLoader?()
                    self.showError?(error)
                }
            )
        } else {
            manager.getCountries(
                onSuccess: { [weak self] model in
                    guard let self = self else { return }
                    self.model = model
                    self.countries = model.map({ CountryViewModel(name: $0.name, alpha2Code: $0.alpha2Code) })
                    self.dismissLoader?()
                    self.updateGridView?()
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    self.dismissLoader?()
                    self.showError?(error)
                }
            )
        }
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

// MARK: - RegionViewModel, CountryViewModel
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
