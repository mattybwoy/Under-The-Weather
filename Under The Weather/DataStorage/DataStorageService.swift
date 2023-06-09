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
    
    public var userCities: [Data]
    
    private init(userCities: [Data] = []) {
        self.userCities = userCities
    }
    
    func addUserCity(city: Cities) {
        guard let convertedCity = DataConverter().convertCity(city: city) else {
            return
        }
        userCities.append(convertedCity)
        defaults.set(userCities, forKey: "UserCities")
    }
    
    func loadUserCities() {
        userCities = defaults.object(forKey:"UserCities") as? [Data] ?? []
    }
    
    func checkCityExists(city: Cities) -> Bool {
        //Require Decoding before checking
        return userCities.filter({ $0 == city}).count > 0 ? true : false
    }
    
}
