//
//  WeatherEndpoint.swift
//  Under The Weather
//
//  Created by Matthew Lock on 13/01/2024.
//

import Foundation

struct WeatherEndpoint: Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
    var type: URLPath
}

extension WeatherEndpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "meteosource.com"
        components.path = type.rawValue
        components.queryItems = queryItems
        components.queryItems?.append(URLQueryItem(name: "key", value: APIKeysProvider().weatherApiKey!))
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
}

extension WeatherEndpoint {
    public static func citySearch(with city: String) -> Self {
        WeatherEndpoint(path: city,
                        queryItems: [URLQueryItem(name: "text", value: city),
                                     URLQueryItem(name: "language", value: "en")
                                    ], type: .city)
    }
    
    static func cityWeatherURL(with city: String) -> Self {
        WeatherEndpoint(path: city, queryItems: [URLQueryItem(name: "place_id", value: city),
                                                 URLQueryItem(name: "sections", value: "all"),
                                                 URLQueryItem(name: "language", value: "en"),
                                                 URLQueryItem(name: "units", value: "uk"),
                                                ], type: .cityWeather)
    }
}

enum URLPath: String {
    case city = "/api/v1/free/find_places_prefix"
    case cityWeather = "/api/v1/free/point"
}
