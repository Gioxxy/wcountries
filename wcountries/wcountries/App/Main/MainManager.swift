//
//  MainManager.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 27/02/21.
//

import Foundation

class MainManager {
    func getCountries(onSuccess: ((_ mainModel: [CountryModel])->Void)? = nil, onError: ((String)->Void)? = nil){
        CountriesAPI.get(
            route: "/all",
            onSuccess: { data in
                do {
                    let countryModel = try JSONDecoder.init().decode([CountryModel].self, from: data)
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
