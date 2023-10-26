//
//  WeatherViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 29/04/2023.
//

import UIKit

final class WeatherViewController: GenericViewController <WeatherView>, ObservableObject, WeatherDelegate {
    
    private let viewModel: WeatherViewModel

    // the vc shouldn't depend on data storage service and network service directly.
    // these should be depended on by the view model instead
    private let dataStorage: DataStorageService
    private let networkService: NetworkService

    public init(viewModel: WeatherViewModel, dataStorage: DataStorageService = .sharedUserData, networkService: NetworkService = .sharedInstance) {
        self.viewModel = viewModel
        self.dataStorage = dataStorage
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)

        // loading user cities in the `init` method can lead to slow instantiation when
        // working with large data. consider performing this work asynchronously
        dataStorage.loadUserCities()
        let userCities = dataStorage.decodeToUserCityObject()

        // network requests in intialisers aren't common practice. consider performing
        // network-related tasks elsewhere
        networkService.cityWeatherSearch(cities: userCities) { [weak self] _ in }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor(named: "background2")
        rootView.delegate = self
    }
    
    override func loadView() {
        self.view = WeatherView(weatherVC: self)
    }

    func addCitytapped() {
        viewModel.addCityTapped()
    }
    
    func openAbout() {
        viewModel.aboutButtonTapped()
    }
    
    func refreshCities(_ sender: UIButton) {
        networkService.refreshWeather() { [weak self] _ in }
    }
    
}

extension String {
    func convertHourFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: date)
    }
    
    func convertDayFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: date)
    }
    
}
