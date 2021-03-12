//
//  DetailViewModel.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 28/02/21.
//

import Foundation

protocol DetailViewModelDelegate: class {
    func onBackDidTap()
    func onPopGesture()
    func startDetail(model: MainCountryModel)
}

class DetailViewModel {
    private weak var delegate: DetailViewModelDelegate?
    private var manager: DetailManager
    private var neighboringCountriesModel = [MainCountryModel]()
    private(set) var country: CountryViewModel
    private(set) var neighboringCountries: NeighboringCountriesRow?
    
    init(_ delegate: DetailViewModelDelegate? = nil, manager: DetailManager, model: MainCountryModel) {
        self.delegate = delegate
        self.manager = manager
        self.country = CountryViewModel(model: model)
        self.neighboringCountries = nil
    }
    
    func getCountry(alpha3Code: String, onStart: (()->Void)? = nil, onCompletion: (()->Void)? = nil, onSuccess: ((DetailViewModel)->Void)? = nil, onError: ((String)->Void)? = nil){
        onStart?()
        manager.getCountry(
            alpha3Code: alpha3Code,
            onSuccess: { [weak self] model in
                guard let self = self else { return }
                self.country = CountryViewModel(model: model)
                if let borders = model.borders, borders.count > 0 {
                    self.manager.getNeighboringCountries(
                        alpha3Codes: borders,
                        onSuccess: {  [weak self] countries in
                            guard let self = self else { return }
                            if countries.count > 0 {
                                self.neighboringCountriesModel = countries
                                self.neighboringCountries = NeighboringCountriesRow(model: countries)
                            }
                            onCompletion?()
                            onSuccess?(self)
                        },
                        onError: { error in
                            onCompletion?()
                            onError?(error)
                        }
                    )
                } else {
                    onCompletion?()
                    onSuccess?(self)
                }
            },
            onError: { error in
                onCompletion?()
                onError?(error)
            }
        )
    }
    
    func onBackDidTap() {
        delegate?.onBackDidTap()
    }
    
    func onPopGesture(){
        delegate?.onPopGesture()
    }
    
    func onNeighboringCountryDidTap(country: NeighboringCountry){
        if let model = neighboringCountriesModel.first(where: { $0.alpha2Code == country.alpha2Code}){
            delegate?.startDetail(model: model)
        }
    }
}

// MARK: - CountryViewModel, RegionViewModel, DetailRowViewModel, NeighboringCountriesRow, NeighboringCountry
extension DetailViewModel {
    class CountryViewModel {
        private(set) var name: String
        private(set) var alpha3Code: String
        private(set) var imageURL: URL?
        private(set) var region: RegionViewModel?
        private(set) var currencySymbol: String?
        private(set) var callingCode: String?
        private(set) var details: [DetailRowViewModel] = []
        
        init(model: MainCountryModel){
            self.name = model.name
            self.alpha3Code = model.alpha3Code
            self.imageURL = URL(string: "https://flagcdn.com/h120/\(model.alpha2Code.lowercased()).png")
        }
        
        init(model: CountryModel) {
            self.name = model.name.uppercased()
            self.alpha3Code = model.alpha3Code
            self.imageURL = URL(string: "https://flagcdn.com/h120/\(model.alpha2Code.lowercased()).png")
            
            if let region = model.region {
                self.region = RegionViewModel(region)
            } else {
                self.region = nil
            }
            
            if let currencies = model.currencies, currencies.count > 0 {
                self.currencySymbol = currencies.first?.symbol
            } else {
                self.currencySymbol = nil
            }
            
            if let callingCode = model.callingCodes?.first, callingCode != "" {
                self.callingCode = "+"+callingCode
            } else {
                callingCode = nil
            }
            
            if let nativeName = model.nativeName, nativeName != "" {
                details.append(DetailRowViewModel(title: "Native name", detail: nativeName))
            }
            if let capital = model.capital, capital != "" {
                details.append(DetailRowViewModel(title: "Capital", detail: capital))
            }
            if let population = model.population, population != 0 {
                details.append(DetailRowViewModel(title: "Population", detail: String(format: "%ld", locale: Locale(identifier: "en"), population)))
            }
            if let latlon = model.latlng, latlon.count > 0 {
                details.append(DetailRowViewModel(title: "Latitude longitude", detail: latlon[0].description + ", " + latlon[1].description))
            }
            if let area = model.area, area != 0 {
                details.append(DetailRowViewModel(title: "Area", detail: String(format: "%.2f %@", locale: Locale(identifier: "en"), area, "Km²")))
            }
            if let languages = model.languages, languages.count > 0 {
                let title = languages.count > 1 ? "Languages" : "Language"
                details.append(DetailRowViewModel(title: title, detail: languages.compactMap({$0.name}).joined(separator: ", ")))
            }
            if let timezones = model.timezones, timezones.count > 0 {
                let title = timezones.count > 1 ? "Timezones" : "Timezone"
                details.append(DetailRowViewModel(title: title, detail: timezones.joined(separator: ", ")))
            }
        }
    }
    
    class RegionViewModel {
        let type: RegionType
        let imageName: String?
        
        init(_ type: RegionType) {
            self.type = type
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
                self.imageName = "polar"
            case .Unknow:
                self.imageName = nil
            }
        }
    }
    
    class DetailRowViewModel {
        let title: String
        let detail: String
        
        init(title: String, detail: String){
            self.title = title
            self.detail = detail
        }
    }
    
    class NeighboringCountriesRow {
        let title: String
        let neighboringCountries: [NeighboringCountry]
        
        init(model: [MainCountryModel]) {
            self.title = model.count > 1 ? "Neighboring countries" : "Neighboring country"
            self.neighboringCountries = model.map({NeighboringCountry(alpha2Code: $0.alpha2Code)})
        }
    }
    
    class NeighboringCountry {
        let alpha2Code: String
        let imageURL: URL?
        
        init(alpha2Code: String) {
            self.alpha2Code = alpha2Code
            self.imageURL = URL(string: "https://flagcdn.com/h60/\(alpha2Code.lowercased()).png")
        }
    }
}
