//
//  DetailViewModel.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 28/02/21.
//

import Foundation

protocol DetailViewModelDelegate: class {
    func onBackDidTap()
}

class DetailViewModel {
    private weak var delegate: DetailViewModelDelegate?
    private var manager: DetailManager
    private var model: CountryModel
    
    var name: String
    var alpha3Code: String
    var imageURL: URL?
    var region: RegionViewModel?
    var currencySimbol: String?
    var callingCode: String?
    
    var details: [DetailRowViewModel] = []
    
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
    
    struct DetailRowViewModel {
        let title: String
        let detail: String
    }
    
    init(_ delegate: DetailViewModelDelegate, manager: DetailManager, model: CountryModel) {
        self.delegate = delegate
        self.manager = manager
        self.model = model
        
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
        
        if let callingCode = model.callingCodes?.first {
            self.callingCode = "+"+callingCode
        } else {
            callingCode = nil
        }
        
        if let nativeName = model.nativeName {
            details.append(DetailRowViewModel(title: "Native name", detail: nativeName))
        }
        if let population = model.population {
            details.append(DetailRowViewModel(title: "Population", detail: String(format: "%ld", locale: Locale.current, population)))
        }
        if let latlon = model.latlng, latlon.count > 0 {
            details.append(DetailRowViewModel(title: "Latitude longitude", detail: latlon[0].description + ", " + latlon[1].description))
        }
        if let area = model.area {
            details.append(DetailRowViewModel(title: "Area", detail: String(format: "%.2f %@", locale: Locale.current, area, "Km²")))
        }
        if let timezones = model.timezones, timezones.count > 0 {
            details.append(DetailRowViewModel(title: "Timezones", detail: timezones.joined(separator: ", ")))
        }
    }
    
    private func setup(model: CountryModel){
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
        
        if let callingCode = model.callingCodes?.first {
            self.callingCode = "+"+callingCode
        } else {
            callingCode = nil
        }
        
        if let nativeName = model.nativeName {
            details.append(DetailRowViewModel(title: "Native name", detail: nativeName))
        }
        if let population = model.population {
            details.append(DetailRowViewModel(title: "Population", detail: String(format: "%ld", locale: Locale.current, population)))
        }
        if let latlon = model.latlng, latlon.count > 0 {
            details.append(DetailRowViewModel(title: "Latitude longitude", detail: latlon[0].description + ", " + latlon[1].description))
        }
        if let area = model.area {
            details.append(DetailRowViewModel(title: "Area", detail: String(format: "%.2f %@", locale: Locale.current, area, "Km²")))
        }
        if let timezones = model.timezones, timezones.count > 0 {
            details.append(DetailRowViewModel(title: "Timezones", detail: timezones.joined(separator: ", ")))
        }
    }
    
    func getCountry(onSuccess: ((DetailViewModel)->Void)? = nil, onError: ((String)->Void)? = nil){
        manager.getCountry(
            alpha3Code: model.alpha3Code,
            onSuccess: { [weak self] model in
                guard let `self` = self else { return }
                self.model = model
                self.setup(model: model)
                onSuccess?(self)
            },
            onError: onError
        )
    }
    
    func onBackDidTap() {
        delegate?.onBackDidTap()
    }
}
