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
    
    init(navigationDelegate: WeatherNavigationDelegate, dataStorage: DataStorageService = .sharedUserData, networkService: NetworkService = .sharedInstance) {
        self.navigationDelegate = navigationDelegate
        self.dataStorage = dataStorage
        self.networkService = networkService
        dataStorage.isLoading = true
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
        let userCities = dataStorage.decodeToUserCityObject()
        fetchWeather(userCities: userCities)
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
                        self.dataStorage.isLoading = false
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
}
