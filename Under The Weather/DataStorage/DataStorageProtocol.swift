//
//  DataStorageProtocol.swift
//  Under The Weather
//
//  Created by Matthew Lock on 03/06/2023.
//

import Foundation

protocol DataStorageProtocol {
    func addUserCity(cityObject: [UserCity])
    func loadUserCities()
    func decodeToUserCityObject() -> [UserCity]
    func checkCityExists(city: Cities) -> Bool
    func deleteCity(city: String)
    func addUserCityObject(city: Cities, cityImage: String) -> [UserCity]
}

protocol UserDefaultKey {
    var userKey: String { get set }
}
