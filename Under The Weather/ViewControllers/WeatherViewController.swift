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
        DataStorageService.sharedUserData.decodeToUserCityObject()
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

