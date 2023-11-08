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
            dataStorage.userCity = city
            let searchTermImage = city.name.replacingOccurrences(of: " ", with: "+")
            networkService.fetchCityImages(city: searchTermImage) { [weak self] result in
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
        selected = nil
        dataStorage.userSearchResults? = []
        hasSeenIntro()
    }
    
    @MainActor
    func searchCityWeather(userCity: [UserCity]) {
        networkService.cityWeatherSearch(cities: userCity) { [weak self] _ in
        }
    }
    
    @MainActor
    func searchTextDebounce(searchText: String) {
        
        debounceTimer?.invalidate()
        dataStorage.userSearchResults = nil
        selected = nil
        vmDelegate?.reloadData()
        
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [weak self] _ in
            let searchTerm = searchText.replacingOccurrences(of: " ", with: "%20")
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                self?.networkService.citySearch(city: searchTerm) { result in
                    switch result {
                    case .success:
                        self?.vmDelegate?.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        })
    }
    
    func searchButtonClick(searchTerm: String) {
        
        let city = searchTerm.replacingOccurrences(of: " ", with: "%20")
        
        DispatchQueue.main.async {
            self.networkService.citySearch(city: city) { [weak self] result in
                switch result {
                case .success:
                    self?.vmDelegate?.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            self.selected = nil
            self.selectedCity = nil
        }
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

extension CitySearchViewModel {
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
