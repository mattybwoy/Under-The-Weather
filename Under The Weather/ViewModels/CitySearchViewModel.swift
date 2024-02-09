//
//  WeatherViewModel.swift
//  Under The Weather
//
//  Created by Matthew Lock on 30/05/2023.
//

import UIKit

protocol CitySearchNavigationDelegate {
    func citySelectionNextTapped()
    func didDismiss(viewController: UIViewController)
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
    
    @MainActor
    func nextButtonTapped() {
        guard selected != nil else {
            let alert = throwAlert(message: CityAlert.noCitySelected)
            vmDelegate?.presentAlert(alert: alert)
            return
        }
        
        guard let city = selectedCity else {
            return
        }
        
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
                    case .success(let image):
                            let userCities = self?.dataStorage.addUserCityObject(city: city, cityImage: image)
                                self?.searchCityWeather(userCity: userCities ?? [])
                                self?.dataStorage.addUserCity(cityObject: userCities ?? [])

                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            pendingImageRequestWorkItem = requestWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: requestWorkItem)
        }
        selected = nil
        dataStorage.userSearchResults?.removeAll()
        hasSeenIntro()
     }
    
    @MainActor
    func searchCityWeather(userCity: [UserCity]) {
        dataStorage.userWeatherData.removeAll()
        pendingWeatherRequestWorkItem?.cancel()
        let requestWorkItem = DispatchWorkItem {
            self.networkService.cityWeatherSearch(cities: userCity) { [weak self] result in
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
        DispatchQueue.main.async(execute: requestWorkItem)
    }
    
    @MainActor
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
                case .success(let cityResults):
                    DispatchQueue.main.async {
                        self?.dataStorage.userSearchResults = cityResults
                        self?.vmDelegate?.reloadData()
                    }
                case .failure(let error):
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

    func didDismiss(viewController: UIViewController) {
        navigationDelegate.didDismiss(viewController: viewController)
    }
}

private extension CitySearchViewModel {
    func hasSeenIntro() {
        if !UserDefaults.hasSeenAppIntroduction {
            UserDefaults.hasSeenAppIntroduction = true
        }
        navigationDelegate.citySelectionNextTapped()
    }

}

private extension CitySearchViewModel {
    enum CityAlert: String {
        case noCitySelected = "Please select a city"
        case cityAlreadyExists = "City already exists in your favourites please select a different city"
        case maxLimit = "Maximum number of cities exceeded, please delete a city before trying to add another"
    }
}
