//
//  WeatherViewModel.swift
//  Under The Weather
//
//  Created by Matthew Lock on 30/05/2023.
//

import UIKit

protocol WeatherNavigationDelegate {
    func addCityTapped()
    func aboutTapped()
}

final class WeatherViewModel {

    let navigationDelegate: WeatherNavigationDelegate
    public let dataStorage: DataStorageService
    private let networkService: NetworkService
    private var pendingWeatherRequestWorkItem: DispatchWorkItem?
    
    init(navigationDelegate: WeatherNavigationDelegate, dataStorage: DataStorageService = .sharedUserData, networkService: NetworkService = .sharedInstance) {
        self.navigationDelegate = navigationDelegate
        self.dataStorage = dataStorage
        self.networkService = networkService
    }

    func addCityTapped() {
        navigationDelegate.addCityTapped()
    }
    
    func aboutButtonTapped() {
        navigationDelegate.aboutTapped()
    }
    
    @MainActor
    func refreshStoredData() {
        dataStorage.userCityObject.removeAll()
        dataStorage.userWeatherData.removeAll()
        dataStorage.loadUserCities()
        let userCities = dataStorage.decodeToUserCityObject()
        fetchWeather(userCities: userCities)
    }
    
    @MainActor
    func fetchWeather(userCities: [UserCity]) {
        let requestWorkItem = DispatchWorkItem {
            self.networkService.cityWeatherSearch(cities: userCities) { [weak self] result in
                switch result {
                case .success(let weatherResults):
                    var array = [String]()
                    for city in userCities {
                        array.append(city.name)
                    }
                    let tupleDict = Dictionary(uniqueKeysWithValues: (self?.networkService.citiesArray.map { ($0.0, $0) })!)
                    
                    let rearrangedTupleArray = array.compactMap { tupleDict[$0] }
                    var weatherArray = [Weather]()
                    
                    for cityWeather in rearrangedTupleArray {
                        weatherArray.append(cityWeather.1)
                    }

                    DispatchQueue.main.async {
                        self?.dataStorage.userWeatherData = weatherArray
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        pendingWeatherRequestWorkItem = requestWorkItem
        DispatchQueue.main.async(execute: requestWorkItem)
    }
    
}
