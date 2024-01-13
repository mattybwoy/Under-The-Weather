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
    private let apiKeyObject: APIKeysProvider = APIKeysProvider()
    internal var urlSession: URLSession
    
    init(urlSession: URLSession = .shared, dataStorage: DataStorageService = .sharedUserData) {
        self.urlSession = urlSession
        self.dataStorage = dataStorage
    }
    
    func citySearch(city: String, completionHandler: @escaping (Result<[Cities], NetworkError>) -> Void) {
        guard let _ = apiKeyObject.weatherApiKey else {
            completionHandler(.failure(NetworkError.invalidKey))
            return
        }
        
        let task = urlSession.dataTask(with: WeatherEndpoint.citySearch(with: city).url) { data, response, error in
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
    
    @MainActor func cityWeatherSearch(cities: [UserCity], completionHandler: @escaping (Result<[Weather], NetworkError>) -> Void) {
        
        guard let _ = apiKeyObject.weatherApiKey else {
            completionHandler(.failure(NetworkError.invalidKey))
            return
        }
        dataStorage.userWeatherData.removeAll()
        
        for city in cities {
            let task = urlSession.dataTask(with: WeatherEndpoint.cityWeatherURL(with: city.place_id).url) { data, response, error in
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
        completionHandler(.success(dataStorage.userWeatherData))
    }
    
    @MainActor func refreshWeather(completionHandler: @escaping (Result<[Weather], NetworkError>) -> Void) {
        guard let _ = apiKeyObject.weatherApiKey else {
            completionHandler(.failure(NetworkError.invalidKey))
            return
        }
        dataStorage.userWeatherData.removeAll()
        
        for city in DataStorageService.sharedUserData.userCityObject {
            let task = urlSession.dataTask(with: WeatherEndpoint.cityWeatherURL(with: city.place_id).url) { data, response, error in
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
        completionHandler(.success(dataStorage.userWeatherData))
    }
    
    func fetchCityImages(city: String, completionHandler: @escaping (Result<String, NetworkError>) -> Void) {
        guard let _ = apiKeyObject.cityImageApiKey else {
            completionHandler(.failure(NetworkError.invalidKey))
            return
        }
        
        let task = urlSession.dataTask(with: ImageEndpoint(path: city).url) { data, response, error in
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
