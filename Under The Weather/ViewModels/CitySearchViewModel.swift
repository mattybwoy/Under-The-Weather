//
//  CitySearchViewModel.swift
//  Under The Weather
//
//  Created by Matthew Lock on 30/05/2023.
//

import UIKit

protocol CitySearchNavigationDelegate {
    func didTapCitySearchPrimaryCTA()
}

protocol CityVMDelegate: AnyObject {
    func presentAlert(alert: UIAlertController)
    func reloadData()
}

final class CitySearchViewModel: CityDelegate {

    var selected: Int?
    var selectedCity: Cities?
    private var debounceTimer: Timer?
    let navigationDelegate: CitySearchNavigationDelegate
    weak var vmDelegate: CityVMDelegate?
    public let dataStorage: DataStorageService
    private let networkService: NetworkService
    private var pendingCityRequestWorkItem: DispatchWorkItem?
    private var pendingImageRequestWorkItem: DispatchWorkItem?
    private var pendingWeatherRequestWorkItem: DispatchWorkItem?

    init(navigationDelegate: CitySearchNavigationDelegate, dataStorage: DataStorageService = .sharedUserData, networkService: NetworkService = .sharedInstance) {
        self.navigationDelegate = navigationDelegate
        self.dataStorage = dataStorage
        self.networkService = networkService
    }

    func bind(to view: CitySearchView) {
        view.delegate = self
    }

    func nextButtonTapped() {
        guard selected != nil else {
            let alert = throwAlert(message: CityAlert.noCitySelected)
            vmDelegate?.presentAlert(alert: alert)
            return
        }

        guard let city = selectedCity else {
            return
        }
        dataStorage.isLoading = true
        dataStorage.loadUserCities()
        dataStorage.decodeToUserCityObject()

        if dataStorage.checkCityExists(city: city) {
            let alert = throwAlert(message: CityAlert.cityAlreadyExists)
            vmDelegate?.presentAlert(alert: alert)
            return
        }

        if dataStorage.userCityObject.count > 5 {
            let alert = throwAlert(message: CityAlert.maxLimit)
            vmDelegate?.presentAlert(alert: alert)
            return
        } else {
            pendingImageRequestWorkItem?.cancel()
            dataStorage.userCity = city
            let requestWorkItem = DispatchWorkItem {
                self.networkService.fetchCityImages(city: city.name) { [weak self] result in
                    switch result {
                    case let .success(image):
                        let userCities = self?.dataStorage.addUserCityObject(city: city, cityImage: image)
                        self?.searchCityWeather(userCities: userCities ?? [])
                        self?.dataStorage.addUserCity(cityObject: userCities ?? [])
                        self?.dataStorage.isLoading = false
                    case let .failure(error):
                        print(error.localizedDescription)
                    }
                }
            }
            pendingImageRequestWorkItem = requestWorkItem
            DispatchQueue.main.async(execute: requestWorkItem)
        }
        selected = nil
        dataStorage.userSearchResults?.removeAll()
        hasSeenIntro()
    }

    func searchCityWeather(userCities: [UserCity]) {
        dataStorage.userWeatherData.removeAll()
        pendingWeatherRequestWorkItem?.cancel()
        let requestWorkItem = DispatchWorkItem {
            self.networkService.cityWeatherSearch(cities: userCities) { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case let .success(weatherResults):
                    DispatchQueue.main.async {
                        self.dataStorage.userWeatherData = weatherResults
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
        pendingWeatherRequestWorkItem = requestWorkItem
        DispatchQueue.main.async(execute: requestWorkItem)
    }

    func searchTextDebounce(searchText: String) {

        debounceTimer?.invalidate()
        dataStorage.userSearchResults = nil
        selected = nil
        vmDelegate?.reloadData()

        debounceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [weak self] _ in
            self?.searchButtonClick(searchTerm: searchText)
        })
    }

    func searchButtonClick(searchTerm: String) {

        pendingCityRequestWorkItem?.cancel()

        let requestWorkItem = DispatchWorkItem {
            self.networkService.citySearch(city: searchTerm) { [weak self] result in
                switch result {
                case let .success(cityResults):
                    DispatchQueue.main.async {
                        self?.dataStorage.userSearchResults = cityResults
                        self?.vmDelegate?.reloadData()
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
        pendingCityRequestWorkItem = requestWorkItem
        DispatchQueue.main.async(execute: requestWorkItem)
        self.selected = nil
        self.selectedCity = nil
    }

    fileprivate func throwAlert(message: CityAlert) -> UIAlertController {
        let alert = UIAlertController(title: "Alert", message: message.rawValue, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
}

private extension CitySearchViewModel {
    func hasSeenIntro() {
        if !UserDefaults.hasSeenAppIntroduction {
            UserDefaults.hasSeenAppIntroduction = true
        }
        navigationDelegate.didTapCitySearchPrimaryCTA()
    }

}

private extension CitySearchViewModel {
    enum CityAlert: String {
        case noCitySelected = "Please select a city"
        case cityAlreadyExists = "City already exists in your favourites please select a different city"
        case maxLimit = "Maximum number of cities exceeded, please delete a city before trying to add another"
    }
}
