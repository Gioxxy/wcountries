//
//  LangFilterModel.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 06/03/21.
//

import Foundation

// MARK: - LangFilterModel
struct LangFilterModel: Decodable {
    let languages: [LanguageModel]
}
