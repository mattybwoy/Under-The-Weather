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
    
    public var userCities: [String]?
    
    private init(userCities: [String] = []) {
        self.userCities = userCities
    }
    
    func addUserCity(cityId: String) {
        defaults.set(cityId, forKey: "UserCities")
    }
    
    func loadUserCities() -> [String] {
        userCities = defaults.object(forKey:"UserCities") as? [String] ?? [String]()
        return userCities ?? []
    }
    
}
