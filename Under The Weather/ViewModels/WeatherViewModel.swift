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

final class WeatherViewModel: ObservableObject {

    let navigationDelegate: WeatherNavigationDelegate
    public let dataStorage: DataStorageService
    private let networkService: NetworkService
    private var pendingWeatherRequestWorkItem: DispatchWorkItem?

    @Published var userCityObject: [UserCity] = []
    @Published var userWeatherData: [Weather] = []
    @Published var isLoading: Bool?
    
    init(navigationDelegate: WeatherNavigationDelegate, dataStorage: DataStorageService = .sharedUserData, networkService: NetworkService = .sharedInstance) {
        self.navigationDelegate = navigationDelegate
        self.dataStorage = dataStorage
        self.networkService = networkService
        isLoading = true
    }

    func addCityTapped() {
        navigationDelegate.addCityTapped()
    }

    func aboutButtonTapped() {
        navigationDelegate.aboutTapped()
    }

    func refreshStoredData() {
        userCityObject.removeAll()
        dataStorage.userCityObject.removeAll()
        userWeatherData.removeAll()
        dataStorage.userWeatherData.removeAll()
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
                        self.dataStorage.userWeatherData = weatherResults
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
    }
    
    var checkMoreThanOneCity: Bool {
        return dataStorage.checkMoreThanOneCity
    }
    
}
