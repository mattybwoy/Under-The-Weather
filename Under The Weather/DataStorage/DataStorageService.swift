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
    
    public var cityObjects: [Cities]
    public var userCities: Data?
    public var cityImages: [String]?
    
    @Published var cityObjectImage: [[Cities: String]] = [[:]]
    
    private init(cityObjects: [Cities] = []) {
        self.cityObjects = cityObjects
    }

    func addUserCity(city: Cities) {
        guard let convertedCity = DataConverter().encodeCity(city: city) else {
            return
        }
        
        userCities?.append(convertedCity)
        defaults.set(userCities, forKey: "UserCities")
        convertToCityObjects()
    }
    
    func loadUserCities() {
        userCities = defaults.object(forKey:"UserCities") as? Data
    }
    
    @discardableResult func convertToCityObjects() -> [Cities] {
        guard let cities = userCities else {
            return []
        }
        
        cityObjects = DataConverter().decodeCities(data: cities)
        return cityObjects
    }
    
    func checkCityExists(city: Cities) -> Bool {
        guard let cities = userCities else {
            return false
        }
        
        cityObjects = DataConverter().decodeCities(data: cities)
        return cityObjects.filter({ $0 == city }).count > 0 ? true : false
    }
    
    func deleteCity(city: Cities) {
        guard let cities = userCities else {
            return
        }
        
        cityObjects = DataConverter().decodeCities(data: cities)
        
        if let index = cityObjects.firstIndex(of: city) {
            cityObjects.remove(at: index)
        }
        
        userCities = DataConverter().encodeCities(cities: cityObjects)
        defaults.set(userCities, forKey: "UserCities")
    }
    
    func createCityDictionary(city: [Cities], cityImages: [String]) {
        var cityDict = [Cities: String]()
        cityDict = Dictionary(uniqueKeysWithValues: zip(city, cityImages))
        cityObjectImage.append(cityDict)
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
