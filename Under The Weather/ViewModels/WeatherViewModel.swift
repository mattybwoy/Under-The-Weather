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
        pendingWeatherRequestWorkItem?.cancel()
        let requestWorkItem = DispatchWorkItem {
            self.networkService.cityWeatherSearch(cities: userCities) { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case let .success(weatherResults):
                    let weatherArray = self.sortResults(cities: userCities, weatherResults: weatherResults)
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.dataStorage.userWeatherData = weatherArray
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
        pendingWeatherRequestWorkItem = requestWorkItem
        DispatchQueue.main.async(execute: requestWorkItem)
    }

    private func sortResults(cities: [UserCity], weatherResults: [(String, Weather)]) -> [Weather] {

        var cityNames = [String]()
        for city in cities {
            cityNames.append(city.name)
        }
        let tupleDict = Dictionary(uniqueKeysWithValues: (weatherResults.map { ($0.0, $0) }))

        let rearrangedTupleArray = cityNames.compactMap { tupleDict[$0] }
        var weatherArray = [Weather]()

        for cityWeather in rearrangedTupleArray {
            weatherArray.append(cityWeather.1)
        }
        return weatherArray
    }
}
