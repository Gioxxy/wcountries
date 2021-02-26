//
//  Extensions.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 26/02/21.
//

import Foundation

extension URL {
    mutating func appendQueryParam(key: String, value: String?) {
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: key, value: value)
        
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        
        self = urlComponents.url!
    }
    
    mutating func appendQueryParams(_ params: Dictionary<String, String>) {
        params.forEach({ key, value in
            self.appendQueryParam(key: key, value: value)
        })
    }
}
