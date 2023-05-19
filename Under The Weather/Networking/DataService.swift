//
//  DataService.swift
//  Under The Weather
//
//  Created by Matthew Lock on 14/05/2023.
//

import Foundation

protocol DataService {
    var originCity: String? { get set }
    var apiKey: String? { get }
    var urlSession: URLSession { get set }
    
    func prefixCitySearch(city: String, completionHandler: @escaping (Result<[PrefixCities], NetworkError>) -> Void)
}
