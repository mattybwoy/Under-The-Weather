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
    
    public var userCities: Data?
    public var cityImage: String?
    public var userCity: Cities?
    
    @MainActor @Published var userCityObject: [UserCity] = []
    @MainActor @Published var userWeatherData: [Weather] = []

    func addUserCity(cityObject: [UserCity]) {
        guard let convertedCityData = DataConverter().encodeCity(city: cityObject) else {
            return
        }
        userCities = convertedCityData
        defaults.set(userCities, forKey: "UserCities")
    }
    
    func loadUserCities() {
        userCities = defaults.object(forKey:"UserCities") as? Data
    }
    
    @discardableResult func decodeToUserCityObject() -> [UserCity] {
        guard let cities = userCities else {
            return []
        }
        
        userCityObject = DataConverter().decodeCities(data: cities)
        return userCityObject
    }
    
    func checkCityExists(city: Cities) -> Bool {
        guard let cities = userCities else {
            return false
        }
        
        userCityObject = DataConverter().decodeCities(data: cities)
        
        let result = userCityObject.contains(where: { cities in
            cities.place_id == city.place_id
        })
        
        return result
    }
    
    func deleteCity(city: Cities) {
        guard let cities = userCities else {
            return
        }
        
        userCityObject = DataConverter().decodeCities(data: cities)
        
        userCityObject.removeAll { cities in
            return cities.place_id == city.place_id
        }
        
        userCities = DataConverter().encodeCities(cities: userCityObject)
        defaults.set(userCities, forKey: "UserCities")
    }
    
    func addUserCityObject(city: Cities, cityImage: String) -> [UserCity] {
        let userCityObj = UserCity(name: city.name,
                                   place_id: city.place_id,
                                   country: city.country,
                                   image: cityImage
        )
        userCityObject.append(userCityObj)
        return userCityObject
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
