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
    func fetchWeather() {
        dataStorage.userWeatherData.removeAll()
        dataStorage.loadUserCities()
        let userCities = dataStorage.decodeToUserCityObject()
        let requestWorkItem = DispatchWorkItem {
            self.networkService.cityWeatherSearch(cities: userCities) { [weak self] result in
                switch result {
                case .success(let weatherResults):
                    DispatchQueue.main.async {
                        self?.dataStorage.userWeatherData = weatherResults
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        pendingWeatherRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: requestWorkItem)
    }
    
}
