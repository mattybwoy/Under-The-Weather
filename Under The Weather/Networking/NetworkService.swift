//
//  NetworkService.swift
//  Under The Weather
//
//  Created by Matthew Lock on 13/05/2023.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {

    static let sharedInstance = NetworkService()

    private let apiKeyObject: APIKeysProvider = .init()
    var urlSession: URLSession
    private var citiesArray = [(String, Weather)]()

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func citySearch(city: String, completionHandler: @escaping (Result<[Cities], NetworkError>) -> Void) {
        guard let _ = apiKeyObject.weatherApiKey else {
            completionHandler(.failure(NetworkError.invalidKey))
            return
        }

        let task = urlSession.dataTask(with: WeatherEndpoint.citySearch(with: city).url) { data, _, error in

            guard let data = data, error == nil else {
                completionHandler(.failure(NetworkError.invalidSearch))
                return
            }
            do {
                let response = try
                    JSONDecoder().decode([Cities].self, from: data)
                DispatchQueue.main.async {
                    completionHandler(.success(response))
                }
            } catch {
                completionHandler(.failure(NetworkError.validationError))
                return
            }
        }
        task.resume()
    }

    func cityWeatherSearch(cities: [UserCity], completionHandler: @escaping (Result<[Weather], NetworkError>) -> Void) {
        guard let _ = apiKeyObject.weatherApiKey else {
            completionHandler(.failure(NetworkError.invalidKey))
            return
        }

        let group = DispatchGroup()
        let queue = DispatchQueue(label: UUID().uuidString, qos: .userInitiated, attributes: .concurrent)

        var weatherArray = [Weather?](repeating: nil, count: cities.count)

        for (index, city) in cities.enumerated() {
            queue.async(group: group) { [weak self] in
                group.enter()
                let task = self?.urlSession.dataTask(with: WeatherEndpoint.cityWeatherURL(with: city.place_id).url) {
                    data, _, error in

                    defer { group.leave() }

                    guard let data = data, error == nil else {
                        completionHandler(.failure(NetworkError.invalidKey))
                        return
                    }
                    do {
                        let response = try
                        JSONDecoder().decode(Weather.self, from: data)
                        weatherArray[index] = response
                    } catch {
                        completionHandler(.failure(NetworkError.validationError))
                        return
                    }
                }
                task?.resume()
            }
        }

        group.notify(queue: DispatchQueue.main) {
            if (weatherArray.allSatisfy { $0 != nil }) {
                completionHandler(.success(weatherArray.map { $0! }))
            } else {
                completionHandler(.failure(.validationError))
            }
        }
    }

    func fetchCityImages(city: String, completionHandler: @escaping (Result<String, NetworkError>) -> Void) {
        guard let _ = apiKeyObject.cityImageApiKey else {
            completionHandler(.failure(NetworkError.invalidKey))
            return
        }

        let task = urlSession.dataTask(with: ImageEndpoint(path: city).url) { data, _, error in
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
                    completionHandler(.success(cityPicture))
                }
            } catch {
                completionHandler(.failure(NetworkError.validationError))
                return
            }
        }
        task.resume()
    }

}
