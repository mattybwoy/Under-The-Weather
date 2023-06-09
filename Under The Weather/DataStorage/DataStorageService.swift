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
    
    public var userCities: [Cities]
    
    private init(userCities: [Cities] = []) {
        self.userCities = userCities
    }
    
    func addUserCity(city: Cities) {
        userCities.append(city)
        defaults.set(userCities, forKey: "UserCities")
    }
    
    func loadUserCities() {
        userCities = defaults.object(forKey:"UserCities") as? [Cities] ?? []
    }
    
    func checkCityExists(city: Cities) -> Bool {
        return userCities.filter({ $0 == city}).count > 0 ? true : false
    }
    
}
