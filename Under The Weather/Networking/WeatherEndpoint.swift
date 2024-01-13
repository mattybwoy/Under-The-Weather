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
}

extension WeatherEndpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "meteosource.com"
        components.path = "/api/v1/free/find_places_prefix"
        components.queryItems = [URLQueryItem(name: "text", value: path),
                                URLQueryItem(name: "language", value: "en"),
                                URLQueryItem(name: "key", value: APIKeysProvider().weatherApiKey!)
        ]
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
}

extension WeatherEndpoint {
    static func citySearch(with city: String) -> Self {
        WeatherEndpoint(path: city)
    }
}
