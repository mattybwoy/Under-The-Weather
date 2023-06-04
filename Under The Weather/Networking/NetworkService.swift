//
//  NetworkService.swift
//  Under The Weather
//
//  Created by Matthew Lock on 13/05/2023.
//

import Foundation

class NetworkService: NetworkServiceProtocol {
    

    static let sharedInstance = NetworkService()
    
    internal var urlSession: URLSession
    
    var originCity: String?
    
    var citiesSearchResults: [Cities]? = []
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    var apiKey: String? {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
        guard let key = apiKey, !key.isEmpty else {
            return nil
        }
        return key
    }
    
    func citySearch(city: String, completionHandler: @escaping (Result<[Cities], NetworkError>) -> Void) {
        guard let apiKey else {
            completionHandler(.failure(NetworkError.invalidKey))
            return
        }
        
        if let url = URL(string: "https://www.meteosource.com/api/v1/free/find_places_prefix?text=\(city)&language=en&key=" + apiKey) {
            let task = urlSession.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    completionHandler(.failure(NetworkError.invalidKey))
                    return
                }
                do {
                    let response = try
                    JSONDecoder().decode([Cities].self, from: data)
                    self.citiesSearchResults = response
                    DispatchQueue.main.async {
                        completionHandler(.success(response))
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
