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
    @Published var isLoading: Bool
    
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
        dataStorage.userCityObject.removeAll()
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
                        self.isLoading = false
                        self.dataStorage.userWeatherData = weatherResults
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        pendingWeatherRequestWorkItem = requestWorkItem
        DispatchQueue.global(qos: .userInitiated).async(execute: requestWorkItem)
    }
    
}
