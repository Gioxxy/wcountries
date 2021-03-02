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
}