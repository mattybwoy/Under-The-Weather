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
    var testUserCityObject: [UserCity] = []

    func addUserCity(cityObject: [UserCity]) {
        userCities = DataConverter().encodeCities(cities: cityObject)
        UserDefaults.standard.set(userCities, forKey: userTestKey)
    }

    func loadUserCities() {
        userCities = UserDefaults.standard.object(forKey: userTestKey) as? Data
    }

    func decodeToUserCityObject() -> [UserCity] {
        guard let cities = userCities else {
            return []
        }
        testUserCityObject = DataConverter().decodeCities(data: cities)
        return testUserCityObject
    }

    func checkCityExists(city: Cities) -> Bool {
        return false
    }

    func deleteCity(city: String) {}

    func addUserCityObject(city: Cities, cityImage: String) -> [UserCity] {
        return []
    }

}
