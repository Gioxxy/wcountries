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
    var topLevelDomain: [String]?
    let alpha2Code: String
    let alpha3Code: String
    var callingCodes: [String]?
    var capital: String?
    var altSpellings: [String]?
    var region: RegionType?
    var subregion: String?
    var population: Int?
    var latlng: [Double]?
    var demonym: String?
    var area: Double?
    var gini: Float?
    var timezones: [String]?
    var borders: [String]?
    var nativeName: String?
    var numericCode: String?
    var currencies: [CurrencyModel]?
    var languages: [LanguageModel]?
    var translations: TranslationsModel?
    var flag: URL?
    var regionalBlocs: [RegionalBlocModel]?
    var cioc: String?
}

// MARK: - Currency
struct CurrencyModel: Decodable {
    let code: String?
    let name: String?
    let symbol: String?
}

// MARK: - Language
struct LanguageModel: Decodable {
    let iso639_1: String?
    let iso639_2: String?
    let name: String
    let nativeName: String?
}

// MARK: - RegionalBloc
struct RegionalBlocModel: Decodable {
    let acronym: String?
    let name: String?
    let otherAcronyms: [String]?
    let otherNames: [String]?
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

// MARK: - RegionType
enum RegionType: String, Decodable {
    case Africa
    case Americas
    case Asia
    case Europe
    case Oceania
    case Polar
    case Unknow = ""
}
