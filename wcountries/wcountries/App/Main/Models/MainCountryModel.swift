//
//  MainCountryModel.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 02/03/21.
//

import Foundation

struct MainCountryModel: Decodable {
    let name: String
    let alpha2Code: String
    let alpha3Code: String
}
