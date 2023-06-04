//
//  DataStorageService.swift
//  Under The Weather
//
//  Created by Matthew Lock on 03/06/2023.
//

import Foundation

final class DataStorageService: DataStorageProtocol {
    
    
    public let sharedInstance = DataStorageService()
    
    public var userCities: [String]?
    
    private init(userCities: [String] = []) {
        self.userCities = userCities
    }
    
    func addUserCity(cityId: String) {
        let defaults = UserDefaults.standard
        defaults.set(cityId, forKey: "UserCities")
    }
    
    func loadUserCities() -> [String] {
        let defaults = UserDefaults.standard
        userCities = defaults.object(forKey:"UserCities") as? [String] ?? [String]()
        return userCities ?? []
    }
    
}
