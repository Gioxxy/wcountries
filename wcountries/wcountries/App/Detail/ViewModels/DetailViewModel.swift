//
//  DetailViewModel.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 28/02/21.
//

import Foundation

protocol DetailViewModelDelegate: class {
    func onBackDidTap()
    func onClose()
}

class DetailViewModel {
    private weak var delegate: DetailViewModelDelegate?
    private var manager: DetailManager
    private var model: CountryModel
    var country: CountryViewModel
    var neighboringCountries: NeighboringCountriesRow?
    
    init(_ delegate: DetailViewModelDelegate? = nil, manager: DetailManager, model: CountryModel) {
        self.delegate = delegate
        self.manager = manager
        self.model = model
        self.country = CountryViewModel(model: model)
        self.neighboringCountries = nil
    }
    
    func getCountry(onStart: (()->Void)? = nil, onCompletion: (()->Void)? = nil, onSuccess: ((DetailViewModel)->Void)? = nil, onError: ((String)->Void)? = nil){
        onStart?()
        manager.getCountry(
            alpha3Code: model.alpha3Code,
            onSuccess: { [weak self] model in
                guard let self = self else { return }
                self.model = model
                self.country = CountryViewModel(model: model)
                if let borders = model.borders, borders.count > 0 {
                    self.manager.getAlpha2Codes(
                        alpha3Codes: borders,
                        onSuccess: {  [weak self] bordersAlpha2Codes in
                            guard let self = self else { return }
                            if bordersAlpha2Codes.count > 0 {
                                self.neighboringCountries = NeighboringCountriesRow(alpha2Codes: bordersAlpha2Codes)
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
    
    func onClose(){
        delegate?.onClose()
    }
}

// MARK: - CountryViewModel, RegionViewModel, DetailRowViewModel, NeighboringCountriesRow, NeighboringCountry
extension DetailViewModel {
    class CountryViewModel {
        var name: String
        var alpha3Code: String
        var imageURL: URL?
        var region: RegionViewModel?
        var currencySimbol: String?
        var callingCode: String?
        var details: [DetailRowViewModel] = []
        
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
                self.currencySimbol = currencies.first?.symbol
            } else {
                self.currencySimbol = nil
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
                details.append(DetailRowViewModel(title: "Population", detail: String(format: "%ld", locale: Locale.current, population)))
            }
            if let latlon = model.latlng, latlon.count > 0 {
                details.append(DetailRowViewModel(title: "Latitude longitude", detail: latlon[0].description + ", " + latlon[1].description))
            }
            if let area = model.area, area != 0 {
                details.append(DetailRowViewModel(title: "Area", detail: String(format: "%.2f %@", locale: Locale.current, area, "Km²")))
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
        
        init(alpha2Codes: [String]) {
            self.title = alpha2Codes.count > 1 ? "Neighboring countries" : "Neighboring country"
            self.neighboringCountries = alpha2Codes.map({NeighboringCountry(alpha2Code: $0)})
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
