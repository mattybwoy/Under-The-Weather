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
        DataStorageService.sharedUserData.loadUserCities()
        let userCities = DataStorageService.sharedUserData.decodeToUserCityObject()
        NetworkService.sharedInstance.cityWeatherSearch(cities: userCities) { result in
            switch result {
            case .success(let weather):
                print(weather)
            case .failure(let error):
                print(error)
            }
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
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
    
}

