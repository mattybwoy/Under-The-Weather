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

struct WeatherViewModel {

    let navigationDelegate: WeatherNavigationDelegate
    
    init(navigationDelegate: WeatherNavigationDelegate) {
        self.navigationDelegate = navigationDelegate
    }

    func addCityTapped() {
        navigationDelegate.addCityTapped()
    }
    
    func aboutButtonTapped() {
        navigationDelegate.aboutTapped()
    }
    
}
