//
//  LangFilterManager.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 06/03/21.
//

import Foundation

class LangFilterManager {
    func getLanguages(onSuccess: ((_ mainModel: [LangFilterModel])->Void)? = nil, onError: ((String)->Void)? = nil){
        CountriesAPI.get(
            route: "/all",
            params: ["fields": "languages"],
            onSuccess: { data in
                do {
                    let model = try JSONDecoder.init().decode([LangFilterModel].self, from: data)
                    onSuccess?(model)
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
