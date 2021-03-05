//
//  DetailManager.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 03/03/21.
//

import Foundation

class DetailManager {
    func getCountry(alpha3Code: String, onSuccess: ((_ mainModel: CountryModel)->Void)? = nil, onError: ((String)->Void)? = nil){
        CountriesAPI.get(
            route: "/alpha/"+alpha3Code,
            onSuccess: { data in
                do {
                    let countryModel = try JSONDecoder.init().decode(CountryModel.self, from: data)
                    onSuccess?(countryModel)
                } catch {
                    onError?("Decode error")
                }
            },
            onError: { error in
                onError?(error)
            }
        )
    }
    
    func getAlpha2Codes(alpha3Codes: [String], onSuccess: ((_ mainModel: [String])->Void)? = nil, onError: ((String)->Void)? = nil){
        CountriesAPI.get(
            route: "/alpha",
            params: [
                "codes": alpha3Codes.joined(separator: ";"),
                "fields": "alpha2Code"
            ],
            onSuccess: { data in
                do {
                    let alpha2Codes = try JSONDecoder.init().decode([Dictionary<String, String>].self, from: data).compactMap({ $0["alpha2Code"] })
                    onSuccess?(alpha2Codes)
                } catch {
                    onError?("Decode error")
                }
            },
            onError: { error in
                onError?(error)
            }
        )
    }
}
