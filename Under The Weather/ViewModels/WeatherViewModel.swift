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

protocol DataRefreshDelegate: AnyObject {
    func refresh()
}

final class WeatherViewModel: ObservableObject {
    
    let navigationDelegate: WeatherNavigationDelegate
    let dataStorage: DataStorageService
    private let networkService: NetworkService
    private var pendingWeatherRequestWorkItem: DispatchWorkItem?
    
    @Published var userCityObject: [UserCity] = []
    @Published var userWeatherData: [Weather] = []
    @Published var isLoading: Bool?
    @Published var viewedCity: String = ""
    @Published var addCityAlert: Bool = false
    var selected: Int = 0
    
    init(navigationDelegate: WeatherNavigationDelegate, dataStorage: DataStorageService = .sharedUserData, networkService: NetworkService = .sharedInstance) {
        self.navigationDelegate = navigationDelegate
        self.dataStorage = dataStorage
        self.networkService = networkService
        isLoading = true
        dataStorage.dataRefreshDelegate = self
    }

    func addCityTapped() {
        navigationDelegate.addCityTapped()
    }

    func aboutButtonTapped() {
        navigationDelegate.aboutTapped()
    }

    func refreshStoredData() {
        isLoading = true
        userCityObject.removeAll()
        userWeatherData.removeAll()
        dataStorage.loadUserCities()
        userCityObject = dataStorage.decodeToUserCityObject()
        fetchWeather(userCities: userCityObject)
    }

    func fetchWeather(userCities: [UserCity]) {
        pendingWeatherRequestWorkItem?.cancel()
        let requestWorkItem = DispatchWorkItem {
            self.networkService.cityWeatherSearch(cities: userCities) { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case let .success(weatherResults):
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.userWeatherData = weatherResults
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
        pendingWeatherRequestWorkItem = requestWorkItem
        DispatchQueue.global(qos: .userInitiated).async(execute: requestWorkItem)
    }
    
    func deleteCity(city: String) {
        dataStorage.deleteCity(city: city)
        refreshStoredData()
    }
    
    var checkMoreThanOneCity: Bool {
        return dataStorage.checkMoreThanOneCity
    }
    
    var checkIfOverCityLimit: Bool {
        return dataStorage.userCityObject.count == 5
    }
    
}

extension WeatherViewModel: DataRefreshDelegate {
    
    func refresh() {
        refreshStoredData()
    }
    
}
