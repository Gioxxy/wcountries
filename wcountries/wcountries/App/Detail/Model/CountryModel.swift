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
    var topLevelDomain: [String]? = nil
    let alpha2Code: String
    let alpha3Code: String
    var callingCodes: [String]? = nil
    var capital: String? = nil
    var altSpellings: [String]? = nil
    var region: RegionType? = nil
    var subregion: String? = nil
    var population: Int? = nil
    var latlng: [Float]? = nil
    var demonym: String? = nil
    var area: Double? = nil
    var gini: Float? = nil
    var timezones: [String]? = nil
    var borders: [String]? = nil
    var nativeName: String? = nil
    var numericCode: String? = nil
    var currencies: [CurrencyModel]? = nil
    var languages: [LanguageModel]? = nil
    var translations: TranslationsModel? = nil
    var flag: URL? = nil
    var regionalBlocs: [RegionalBlocModel]? = nil
    var cioc: String? = nil
    
    init(name: String, alpha2Code: String, alpha3Code: String) {
        self.name = name
        self.alpha2Code = alpha2Code
        self.alpha3Code = alpha3Code
    }
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
