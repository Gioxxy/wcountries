//
//  MainManager.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 27/02/21.
//

import Foundation

class MainManager {
    func getCountries(onSuccess: ((_ mainModel: [MainCountryModel])->Void)? = nil, onError: ((String)->Void)? = nil){
        CountriesAPI.get(
            route: "/all",
            params: ["fields": "name;alpha2Code;alpha3Code"],
            onSuccess: { data in
                do {
                    let countryModel = try JSONDecoder.init().decode([MainCountryModel].self, from: data)
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
    
    func getCountriesBy(continent: MainViewModel.RegionViewModel, onSuccess: ((_ mainModel: [MainCountryModel])->Void)? = nil, onError: ((String)->Void)? = nil){
        CountriesAPI.get(
            route: "/region/"+continent.type.rawValue.lowercased(),
            params: ["fields": "name;alpha2Code;alpha3Code"],
            onSuccess: { data in
                do {
                    let countryModel = try JSONDecoder.init().decode([MainCountryModel].self, from: data)
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
    
    func getCountriesBy(iso639_2: String, onSuccess: ((_ mainModel: [MainCountryModel])->Void)? = nil, onError: ((String)->Void)? = nil){
        CountriesAPI.get(
            route: "/lang/"+iso639_2,
            params: ["fields": "name;alpha2Code;alpha3Code"],
            onSuccess: { data in
                do {
                    let countryModel = try JSONDecoder.init().decode([MainCountryModel].self, from: data)
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
