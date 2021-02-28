//
//  MainViewModel.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 27/02/21.
//

import Foundation

class MainViewModel {
    private var model: [CountryModel]
    let regions: [RegionViewModel]
    let countries: [CountryViewModel]
    
    init(model: [CountryModel]) {
        self.model = model
        regions = [
            RegionViewModel(.Africa, imageName: "africa"),
            RegionViewModel(.Americas, imageName: "americas"),
            RegionViewModel(.Asia, imageName: "asia"),
            RegionViewModel(.Europe, imageName: "europa"),
            RegionViewModel(.Oceania, imageName: "oceania")
        ]
        countries = model.map({ CountryViewModel(name: $0.name, alpha2Code: $0.alpha2Code) })
    }
}

class RegionViewModel {
    let type: RegionType
    let imageName: String
    let isSelected: Bool
    
    init(_ type: RegionType, imageName: String, isSelected: Bool = false){
        self.type = type
        self.imageName = imageName
        self.isSelected = isSelected
    }
}

class CountryViewModel {
    let name: String
    let imageURL: URL?
    
    init(name: String, alpha2Code: String) {
        self.name = name.uppercased()
        self.imageURL = URL(string: "https://flagcdn.com/h60/\(alpha2Code.lowercased()).png")
    }
}
