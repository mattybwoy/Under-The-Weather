//
//  WeatherViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 29/04/2023.
//

import UIKit

final class WeatherViewController: GenericViewController <WeatherView>, ObservableObject, delegateProtocol {
    
    private let viewModel: WeatherViewModel
    private let dataStorage: DataStorageService
    private let networkService: NetworkService

    public init(viewModel: WeatherViewModel, dataStorage: DataStorageService = .sharedUserData, networkService: NetworkService = .sharedInstance) {
        self.viewModel = viewModel
        self.dataStorage = dataStorage
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
        dataStorage.loadUserCities()
        let userCities = dataStorage.decodeToUserCityObject()
        networkService.cityWeatherSearch(cities: userCities) { [weak self] result in
            switch result {
            case .success(let weather):
                print("success")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
    }
    
    override func loadView() {
        self.view = WeatherView(weatherVC: self)
    }

    private var contentView: WeatherView {
        view as! WeatherView
    }

    func addCitytapped() {
        viewModel.nextButtonTapped()
    }
    
    func openAbout() {
        viewModel.aboutButtonTapped()
    }
    
    func refreshCities(_ sender: UIButton) {
        networkService.refreshWeather() { result in
            switch result {
            case .success:
                print("refreshed!")
                break
            case .failure:
                break
            }
        }
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
