//
//  DataStorageProtocol.swift
//  Under The Weather
//
//  Created by Matthew Lock on 03/06/2023.
//

import Foundation

protocol DataStorageProtocol {
    var userCities: [Cities] { get }
    func addUserCity(city: Cities)
    func loadUserCities()
    func checkCityExists(city: Cities) -> Bool
}
