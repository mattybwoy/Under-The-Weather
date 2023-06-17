//
//  NetworkService.swift
//  Under The Weather
//
//  Created by Matthew Lock on 13/05/2023.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    
    static let sharedInstance = NetworkService()
    
    internal var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    var weatherApiKey: String? {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
        guard let key = apiKey, !key.isEmpty else {
            return nil
        }
        return key
    }
    
    var cityImageApiKey: String? {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "CITY_API_KEY") as? String
        guard let key = apiKey, !key.isEmpty else {
            return nil
        }
        return key
    }
    
    func citySearch(city: String, completionHandler: @escaping (Result<[Cities], NetworkError>) -> Void) {
        guard let weatherApiKey else {
            completionHandler(.failure(NetworkError.invalidKey))
            return
        }
        
        if let url = URL(string: "https://www.meteosource.com/api/v1/free/find_places_prefix?text=\(city)&language=en&key=" + weatherApiKey) {
            let task = urlSession.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    completionHandler(.failure(NetworkError.invalidKey))
                    return
                }
                do {
                    let response = try
                    JSONDecoder().decode([Cities].self, from: data)
                    DataStorageService.sharedUserData.userSearchResults = response
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
    
    func cityWeatherSearch(cities: [Cities], completionHandler: @escaping (Result<Weather, NetworkError>) -> Void) {
        
    }
    
    func fetchCityImages(city: String, completionHandler: @escaping (Result<String, NetworkError>) -> Void) {
        guard let cityImageApiKey else {
            completionHandler(.failure(NetworkError.invalidKey))
            return
        }
        
        if let url = URL(string: "https://pixabay.com/api/?key=" + cityImageApiKey + "&q=\(city)&image_type=photo") {
            let task = urlSession.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    completionHandler(.failure(NetworkError.invalidKey))
                    return
                }
                do {
                    let response = try
                    JSONDecoder().decode(CityImages.self, from: data)
                    guard let cityPicture = response.hits.first?.previewURL else {
                        return
                    }
                    DataStorageService.sharedUserData.cityImage = cityPicture
                    completionHandler(.success(cityPicture))
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
