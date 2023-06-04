//
//  NetworkServiceProtocol.swift
//  Under The Weather
//
//  Created by Matthew Lock on 14/05/2023.
//

import Foundation

protocol NetworkServiceProtocol {
    var originCity: String? { get set }
    var apiKey: String? { get }
    var urlSession: URLSession { get set }
    
    func citySearch(city: String, completionHandler: @escaping (Result<[Cities], NetworkError>) -> Void)
}
