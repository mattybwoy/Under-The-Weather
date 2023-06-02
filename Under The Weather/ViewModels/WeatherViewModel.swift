//
//  WeatherViewModel.swift
//  Under The Weather
//
//  Created by Matthew Lock on 30/05/2023.
//

import Foundation

final class WeatherViewModel {
    
    typealias Routes = WeatherRoute & Closable & Dismissable & LaunchScreenRoute
    private var router: Routes
    
    init(router: Routes) {
        self.router = router
    }
    
    func nextButtonTapped() {
        router.openCitySearch1()
    }
    
}
