//
//  NetworkServiceProtocol.swift
//  Under The Weather
//
//  Created by Matthew Lock on 14/05/2023.
//

import Foundation

protocol NetworkServiceProtocol {
    var weatherApiKey: String? { get }
    var cityImageApiKey: String? { get }
    var urlSession: URLSession { get set }
    
    func citySearch(city: String, completionHandler: @escaping (Result<[Cities], NetworkError>) -> Void)
    func cityWeatherSearch(cities: [Cities], completionHandler: @escaping (Result<Weather, NetworkError>) -> Void)
    func fetchCityImages(city: String, completionHandler: @escaping (Result<String, NetworkError>) -> Void)
}
