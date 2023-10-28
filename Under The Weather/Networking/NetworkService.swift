//
//  NetworkService.swift
//  Under The Weather
//
//  Created by Matthew Lock on 13/05/2023.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    
    static let sharedInstance = NetworkService()

    // the network service should only be responsible for network related tasks.
    // consider moving the dependency on data storage elsewhere
    private let dataStorage: DataStorageService
    
    internal var urlSession: URLSession
    
    init(urlSession: URLSession = .shared, dataStorage: DataStorageService = .sharedUserData) {
        self.urlSession = urlSession
        self.dataStorage = dataStorage
    }

    // consider moving the retrieval of API keys to another object (e.g. `APIKeyProvider`)
    // and injecting that object into the network service
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

        // having the url in the networking methods like this isn't common practice.
        // consider abstracting out the creation of the URL to another object. There
        // are several creational design patterns that you can use, namely the factory
        // and builder patterns which are the most popular. Also here's a helpful video:
        // https://www.youtube.com/watch?v=2B4ROZHsaCs
        if let url = URL(string: "https://www.meteosource.com/api/v1/free/find_places_prefix?text=\(city)&language=en&key=" + weatherApiKey) {
            let task = urlSession.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    completionHandler(.failure(NetworkError.invalidSearch))
                    return
                }
                do {
                    let response = try
                    JSONDecoder().decode([Cities].self, from: data)
                    DispatchQueue.main.async {
                        self.dataStorage.userSearchResults = response
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
    
    @MainActor func cityWeatherSearch(cities: [UserCity], completionHandler: @escaping (Result<[Weather], NetworkError>) -> Void) {
        
        guard let weatherApiKey else {
            completionHandler(.failure(NetworkError.invalidKey))
            return
        }
        dataStorage.userWeatherData.removeAll()
        
        for city in cities {
            if let url = URL(string: "https://www.meteosource.com/api/v1/free/point?place_id=\(city.place_id)&sections=all&language=en&units=uk&key=" + weatherApiKey) {
                let task = urlSession.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else {
                        completionHandler(.failure(NetworkError.invalidKey))
                        return
                    }
                    do {
                        let response = try
                        JSONDecoder().decode(Weather.self, from: data)
                        DispatchQueue.main.async {
                            self.dataStorage.userWeatherData.append(response)
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
        completionHandler(.success(dataStorage.userWeatherData))
    }
    
    @MainActor func refreshWeather(completionHandler: @escaping (Result<[Weather], NetworkError>) -> Void) {
        guard let weatherApiKey else {
            completionHandler(.failure(NetworkError.invalidKey))
            return
        }
        dataStorage.userWeatherData.removeAll()
        
        for city in DataStorageService.sharedUserData.userCityObject {
            if let url = URL(string: "https://www.meteosource.com/api/v1/free/point?place_id=\(city.place_id)&sections=all&language=en&units=uk&key=" + weatherApiKey) {
                let task = urlSession.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else {
                        completionHandler(.failure(NetworkError.invalidKey))
                        return
                    }
                    do {
                        let response = try
                        JSONDecoder().decode(Weather.self, from: data)
                        DispatchQueue.main.async {
                            self.dataStorage.userWeatherData.append(response)
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
        completionHandler(.success(dataStorage.userWeatherData))
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
                    DispatchQueue.main.async {
                        self.dataStorage.cityImage = cityPicture
                        completionHandler(.success(cityPicture))
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
