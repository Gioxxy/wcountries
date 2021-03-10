//
//  Extensions.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 26/02/21.
//

import UIKit

// MARK: - URL
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

// MARK: - UIImageView
extension UIImageView {
    func imageFromNetwork(url: URL?, then: ((UIImage)->Void)? = nil) {
        guard let url = url else { return }
        let cache = URLCache(
            memoryCapacity: 0,
            diskCapacity: 100*1024*1024,
            diskPath: "wcountriesImageCache"
        )
        if let data = cache.cachedResponse(for: URLRequest(url: url))?.data {
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async() {
                self.image = image
                then?(image)
            }
        } else {
            let sessionConfiguration = URLSessionConfiguration.default
            sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
            sessionConfiguration.urlCache = cache
            URLSession(configuration: sessionConfiguration).dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() {
                    cache.storeCachedResponse(CachedURLResponse(response: httpURLResponse, data: data), for: URLRequest(url: url))
                    self.image = image
                    then?(image)
                }
            }.resume()
        }
    }
}

// MARK: - Array
extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() // The unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() // Keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}
