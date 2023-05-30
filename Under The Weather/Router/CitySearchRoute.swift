//
//  CitySearchRoute.swift
//  Under The Weather
//
//  Created by Matthew Lock on 30/05/2023.
//

import Foundation
import UIKit

protocol CitySearchRoute {
    func openWeather()
}

extension CitySearchRoute where Self: MainRouter {
    
    func openWeather(with transition: Transition) {
        let router = ScreenRouter(rootTransition: transition)
        let viewModel = WeatherViewModel(router: router)
        let viewController = WeatherViewController(viewModel: viewModel)
        router.root = viewController
        
        route(to: viewController, as: transition)
    }
    
    func openWeather() {
        openWeather(with: PushTransition(isAnimated: true))
    }
    
}

extension ScreenRouter: CitySearchRoute {}
