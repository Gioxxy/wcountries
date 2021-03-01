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
    private var model: CountryModel
    
    let name: String
    let alpha3Code: String
    let imageURL: URL?
    let region: RegionViewModel?
    let currencySimbol: String?
    
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
    
    init(_ delegate: DetailViewModelDelegate, model: CountryModel) {
        self.delegate = delegate
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
        
    }
    
    func onBackDidTap() {
        delegate?.onBackDidTap()
    }
}
