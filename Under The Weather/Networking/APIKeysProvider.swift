//
//  APIKeysProvider.swift
//  Under The Weather
//
//  Created by Matthew Lock on 12/01/2024.
//

import Foundation

struct APIKeysProvider {
    
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
}
