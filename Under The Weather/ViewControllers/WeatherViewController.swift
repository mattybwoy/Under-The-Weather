//
//  WeatherViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 29/04/2023.
//

import UIKit

class WeatherViewController: GenericViewController <WeatherView> {
    
    private let viewModel: WeatherViewModel
    
    public init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        DataStorageService.sharedUserData.loadUserCities()
        let userCities = DataStorageService.sharedUserData.decodeToUserCityObject()
        NetworkService.sharedInstance.cityWeatherSearch(cities: userCities) { [weak self] result in
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
        view.backgroundColor = .gray
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshCities))
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func loadView() {
        self.view = WeatherView()
    }

    var contentView: WeatherView {
        view as! WeatherView
    }

    func addCitytapped() {
        viewModel.addCityButtonTapped()
    }
    
    @objc func refreshCities() {
        NetworkService.sharedInstance.refreshWeather() { result in
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
