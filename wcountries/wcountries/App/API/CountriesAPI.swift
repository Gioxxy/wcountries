//
//  CountriesAPI.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 26/02/21.
//

import Foundation

final class CountriesAPI {
    static let server = "https://restcountries.eu/rest/v2"
    static let cache = URLCache(
        memoryCapacity: 0,
        diskCapacity: 100*1024*1024,
        diskPath: "wcountriesCache"
    )
    
    static func get(route: String, params: Dictionary<String, String>? = nil, onSuccess: ((_ data: Data)->Void)? = nil, onError: ((String)->Void)? = nil){
        
        guard route.count > 0 else { onError?("Empty route"); return }
        
        var url = URL(string: server + route)!
        if let params = params {
            url.appendQueryParams(params)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = .useProtocolCachePolicy
        
//        if let data = cache.cachedResponse(for: request)?.data, let response = cache.cachedResponse(for: request)?.response {
//            guard let response = response as? HTTPURLResponse else {
//                print("Not a HTTP response")
//                onError?()
//                return
//            }
//            guard response.statusCode == 200 else {
//                print("Invalid HTTP status code \(response.statusCode)")
//                onError?()
//                return
//            }
//            onSuccess?(data)
//        } else {
            let sessionConfiguration = URLSessionConfiguration.default
            sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
            sessionConfiguration.urlCache = cache
            URLSession(configuration: sessionConfiguration).dataTask(with: request, completionHandler: { data, response, error -> Void in
                
                if let error = error {
                    print("Network error: " + error.localizedDescription)
                    DispatchQueue.main.async {
                        onError?("Network error")
                    }
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    print("Not a HTTP response")
                    DispatchQueue.main.async {
                        onError?("Network error")
                    }
                    return
                }
                guard response.statusCode == 200 else {
                    print("Invalid HTTP status code \(response.statusCode)")
                    DispatchQueue.main.async {
                        onError?("Network error")
                    }
                    return
                }
                guard let data = data else {
                    print("No HTTP data")
                    DispatchQueue.main.async {
                        onError?("Network error")
                    }
                    return
                }
                
                cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                DispatchQueue.main.async {
                    onSuccess?(data)
                }
            }).resume()
//        }

       
    }
}
