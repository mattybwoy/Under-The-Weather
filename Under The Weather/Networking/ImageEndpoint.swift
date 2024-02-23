//
//  ImageEndpoint.swift
//  Under The Weather
//
//  Created by Matthew Lock on 12/01/2024.
//

import Foundation

struct ImageEndpoint: Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension ImageEndpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "pixabay.com"
        components.path = "/api/"
        components.queryItems = [URLQueryItem(name: "key", value: APIKeysProvider().cityImageApiKey!),
                                 URLQueryItem(name: "q", value: path),
                                 URLQueryItem(name: "image_type", value: "photo")]

        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }

        return url
    }
}

extension ImageEndpoint {
    static func cityImagesURL(with city: String) -> Self {
        ImageEndpoint(path: city)
    }
}
