//
//  DataStorageProtocol.swift
//  Under The Weather
//
//  Created by Matthew Lock on 03/06/2023.
//

import Foundation

protocol DataStorageProtocol {
    //func addUserCity(city: Cities)
    func loadUserCities()
    func checkCityExists(city: Cities) -> Bool
    func deleteCity(city: Cities)
}
