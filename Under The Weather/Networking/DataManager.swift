//
//  DataManager.swift
//  Under The Weather
//
//  Created by Matthew Lock on 13/05/2023.
//

import Foundation

class DataManager {
    
    static let sharedInstance = DataManager()
    
    private var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    var apiKey: String {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
        guard let key = apiKey, !key.isEmpty else {
            print("Key doesn't exist")
            return ""
        }
        return key
    }
    
    func prefixCitySearch(city: String) {
        if let url = URL(string: "https://www.meteosource.com/api/v1/free/find_places_prefix?text=\(city)&language=en&key=" + apiKey) {
            let task = urlSession.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let response = try
                    JSONDecoder().decode([PrefixCities].self, from: data)
                    for city in response {
                        print(city.name)
                    }
                }
                catch {
                    print(error)
                    return
                }
            }
            task.resume()
        }
    }
}
