//
//  CountryModel.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 27/02/21.
//

import Foundation

// MARK: - Country
struct CountryModel: Decodable {
    let name: String
    let topLevelDomain: [String]?
    let alpha2Code: String
    let alpha3Code: String
    let callingCodes: [String]?
    let capital: String?
    let altSpellings: [String]?
    let region: RegionType?
    let subregion: String?
    let population: Int?
    let latlng: [Float]?
    let demonym: String?
    let area: Float?
    let gini: Float?
    let timezones: [String]?
    let borders: [String]?
    let nativeName: String?
    let numericCode: String?
    let currencies: [CurrencyModel]?
    let languages: [LanguageModel]?
    let translations: TranslationsModel?
    let flag: URL?
    let regionalBlocs: [RegionalBlocModel]?
    let cioc: String?
}

// MARK: - Currency
struct CurrencyModel: Decodable {
    let code: String?
    let name: String?
    let symbol: String?
}

// MARK: - Language
struct LanguageModel: Decodable {
    let iso6391: String?
    let iso6392: String?
    let name: String?
    let nativeName: String?

    enum CodingKeys: String, CodingKey {
        case iso6391 = "iso639_1"
        case iso6392 = "iso639_2"
        case name, nativeName
    }
}

// MARK: - RegionalBloc
struct RegionalBlocModel: Decodable {
    let acronym: String?
    let name: String?
    let otherAcronyms: [String]?
    let otherNames: [String]?
}

enum RegionType: String, Decodable {
    case Africa
    case Americas
    case Asia
    case Europe
    case Oceania
    case Polar
    case Unknow = ""
}

// MARK: - Translations
struct TranslationsModel: Decodable {
    let de: String?
    let es: String?
    let fr: String?
    let ja: String?
    let it: String?
    let br: String?
    let pt: String?
}
