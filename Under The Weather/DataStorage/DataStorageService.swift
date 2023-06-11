//
//  DataStorageService.swift
//  Under The Weather
//
//  Created by Matthew Lock on 03/06/2023.
//

import Foundation

final class DataStorageService: DataStorageProtocol {
    
    static let sharedUserData = DataStorageService()
    
    private let defaults = UserDefaults.standard
    
    public var cityObjects: [Cities]
    public var userCities: Data?
    
    private init(cityObjects: [Cities] = []) {
        self.cityObjects = cityObjects
    }
    
    func addUserCity(city: Cities) {
        guard let convertedCity = DataConverter().encodeCity(city: city) else {
            return
        }
        userCities?.append(convertedCity)
        defaults.set(userCities, forKey: "UserCities")
    }
    
    func loadUserCities() {
        userCities = defaults.object(forKey:"UserCities") as? Data
    }
    
    func checkCityExists(city: Cities) -> Bool {

        guard let cities = userCities else {
            return false
        }
        cityObjects = DataConverter().decodeCities(data: cities)
        return cityObjects.filter({ $0 == city }).count > 0 ? true : false
    }
    
}
