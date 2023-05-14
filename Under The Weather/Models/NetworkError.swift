//
//  NetworkErrors.swift
//  Under The Weather
//
//  Created by Matthew Lock on 14/05/2023.
//

import Foundation

public enum NetworkError: Error {
    case invalidSearch
    case invalidKey
    case validationError
}
