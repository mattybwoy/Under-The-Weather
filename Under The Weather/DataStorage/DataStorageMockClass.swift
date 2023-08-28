//
//  DataStorageMockClass.swift
//  Under The Weather
//
//  Created by Matthew Lock on 24/08/2023.
//

import Foundation

final class DataStorageMock: DataStorageProtocol {
    
    var userCityObject: [UserCity] = []
    var userCities: Data?
    var userTestKey: String = ""
    
    func addUserCity(cityObject: [UserCity]) {
        UserDefaults.standard.set(userCities, forKey: userTestKey)
    }
    
    func loadUserCities() {
        userCities = UserDefaults.standard.object(forKey: userTestKey) as? Data
    }
    
    func decodeToUserCityObject() -> [UserCity] {
        return []
    }
    
    func checkCityExists(city: Cities) -> Bool {
        return false
    }
    
    func deleteCity(city: String) {
        
    }
    
    func addUserCityObject(city: Cities, cityImage: String) -> [UserCity] {
        return []
    }
    
    
}
