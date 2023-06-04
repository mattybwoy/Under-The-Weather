//
//  DataStorageProtocol.swift
//  Under The Weather
//
//  Created by Matthew Lock on 03/06/2023.
//

import Foundation

protocol DataStorageProtocol {
    var userCities: [String]? { get }
    func addUserCity()
}
