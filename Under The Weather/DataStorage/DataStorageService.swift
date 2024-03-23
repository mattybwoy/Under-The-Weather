//
//  DataStorageService.swift
//  Under The Weather
//
//  Created by Matthew Lock on 03/06/2023.
//

import Foundation

protocol RefreshDelegate: AnyObject {
    func triggerRefresh()
}

final class DataStorageService: DataStorageProtocol, ObservableObject {

    static let sharedUserData = DataStorageService()

    private let defaults = UserDefaults.standard

    public var userSearchResults: [Cities]? = []
    weak var refreshDelegate: RefreshDelegate?
    weak var dataRefreshDelegate: DataRefreshDelegate?
    public var userCities: Data?
    public var userCity: Cities?
    var userCityObject: [UserCity] = []
    var userWeatherData: [Weather] = []
    
    func addUserCity(cityObject: [UserCity]) {
        guard let convertedCityData = DataConverter().encodeCities(cities: cityObject) else {
            return
        }
        userCities = convertedCityData
        defaults.set(userCities, forKey: Keys.savedCities)
    }

    func loadUserCities() {
        userCities = defaults.object(forKey: Keys.savedCities) as? Data
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
    
    public var userCityObjectCountGreaterThanFive: Bool {
        userCityObject.count > 5
    }

    var checkMoreThanOneCity: Bool {
        userCityObject.count > 1
    }

    func deleteCity(city: String) {
        guard let cities = userCities else {
            return
        }

        userCityObject = DataConverter().decodeCities(data: cities)

        userCityObject.removeAll { cities in
            cities.place_id == city
        }

        userCities = DataConverter().encodeCities(cities: userCityObject)
        defaults.set(userCities, forKey: Keys.savedCities)
    }

    func addUserCityObject(city: Cities, cityImage: String) -> [UserCity] {
        let userCityObj = UserCity(name: city.name,
                                   place_id: city.place_id,
                                   country: city.country,
                                   image: cityImage)
        userCityObject.append(userCityObj)
        return userCityObject
    }
    
    func willRefresh() {
        //Trigger delegate here
        refresh()
    }

}

extension DataStorageService: DataRefreshDelegate {
    
    func refresh() {
        dataRefreshDelegate?.refresh()
    }
    
}

@propertyWrapper
struct UserDefault<Bool> {
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

extension UserDefaults: UserDefaultKey {

    var userKey: String {
        get {
            Keys.savedCities
        }
        set {
            Keys.savedCities = newValue
        }
    }

    @UserDefault(key: "has_seen_app_introduction", defaultValue: false)
    static var hasSeenAppIntroduction: Bool
}

public enum Keys {
    static var savedCities = "UserCities"
}
