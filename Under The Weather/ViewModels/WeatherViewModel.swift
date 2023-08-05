//
//  WeatherViewModel.swift
//  Under The Weather
//
//  Created by Matthew Lock on 30/05/2023.
//

import Foundation

final class WeatherViewModel: ViewModelProtocol {
    
    typealias Routes =  WeatherRoute & LaunchScreenRoute & Closable & CitySearchRoute
    var router: Routes
    
    init(router: Routes) {
        self.router = router
    }
    
    func nextButtonTapped() {
        router.openCitySearch()
        //router.addCity()
    }
    
    func aboutButtonTapped() {
        router.openAbout()
    }
    
}
