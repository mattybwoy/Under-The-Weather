//
//  DataManager.swift
//  Under The Weather
//
//  Created by Matthew Lock on 13/05/2023.
//

import Foundation

class DataManager: DataService {

    static let sharedInstance = DataManager()
    
    internal var urlSession: URLSession
    
    var originCity: String?
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    var apiKey: String {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
        guard let key = apiKey, !key.isEmpty else {
            return ""
        }
        return key
    }
    
    func prefixCitySearch(city: String, completionHandler: @escaping (Result<Any, NetworkError>) -> Void) {
        if let url = URL(string: "https://www.meteosource.com/api/v1/free/find_places_prefix?text=\(city)&language=en&key=" + apiKey) {
            let task = urlSession.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    completionHandler(.failure(NetworkError.invalidKey))
                    return
                }
                do {
                    let response = try
                    JSONDecoder().decode([PrefixCities].self, from: data)
                    for eachCity in response {
                        completionHandler(.success(self.originCity = eachCity.name))
                    }
                }
                catch {
                    completionHandler(.failure(NetworkError.validationError))
                    return
                }
            }
            task.resume()
        }
    }
    
}
