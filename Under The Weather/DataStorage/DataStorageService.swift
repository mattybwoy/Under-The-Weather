//
//  DataStorageService.swift
//  Under The Weather
//
//  Created by Matthew Lock on 03/06/2023.
//

import Foundation

final class DataStorageService: DataStorageProtocol, ObservableObject {
    
    static let sharedUserData = DataStorageService()
    
    private let defaults = UserDefaults.standard
    
    public var userSearchResults: [Cities]? = []
    
    public var cities: [Cities]? = []
    public var userCities: Data?
    public var cityImage: String?
    public var userCity: Cities?
    
    @Published var cityObject: [[Cities: String]] = [[:]]

    func addUserCity(cityObject: [[Cities: String]]) {
        guard let convertedCityData = DataConverter().encodeCity(city: cityObject) else {
            return
        }
        userCities?.append(convertedCityData)
        defaults.set(userCities, forKey: "UserCities")
    }
    
    func loadUserCities() {
        userCities = defaults.object(forKey:"UserCities") as? Data
    }
    
    @discardableResult func convertToCityObjects() -> [[Cities: String]] {
        guard let cities = userCities else {
            return [[:]]
        }
        
        cityObject = DataConverter().decodeCities(data: cities)
        return cityObject
    }
    
    func checkCityExists(city: Cities) -> Bool {
        guard let cities = userCities else {
            return false
        }
        
        cityObject = DataConverter().decodeCities(data: cities)
        
        var result: Bool = false
        for cities in cityObject {
            result = cities.contains { $0.key == city }
        }
        return result
    }
    
    func deleteCity(city: Cities) {
        guard let cities = userCities else {
            return
        }
        
        cityObject = DataConverter().decodeCities(data: cities)
        
        cityObject = cityObject.filter{ $0[city] == nil }
        
        userCities = DataConverter().encodeCities(cities: cityObject)
        defaults.set(userCities, forKey: "UserCities")
    }
    
    func addCityToDictionary(city: Cities, cityImage: String) {
        var cityDict = [city: cityImage]
        cityObject.append(cityDict)
    }
    
}

@propertyWrapper
struct UserDefault <Bool> {
    let key: String
    let defaultValue: Bool
    var container: UserDefaults = .standard

    var wrappedValue: Bool {
        get {
            return container.object(forKey: key) as? Bool ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

extension UserDefaults {

    @UserDefault(key: "has_seen_app_introduction", defaultValue: false)
    static var hasSeenAppIntroduction: Bool
}
