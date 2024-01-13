//
//  Endpoint.swift
//  Under The Weather
//
//  Created by Matthew Lock on 13/01/2024.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}
