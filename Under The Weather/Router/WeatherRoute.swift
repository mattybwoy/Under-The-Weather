//
//  WeatherRoute.swift
//  Under The Weather
//
//  Created by Matthew Lock on 30/05/2023.
//

import Foundation
import UIKit

protocol WeatherRoute {
    func openCitySearch1()
}

extension WeatherRoute where Self: MainRouter {
    
    func openCitySearch1(with transition: Transition) {
        
        let router = ScreenRouter(rootTransition: transition)
        let viewModel = CitySearchViewModel(router: router)
        let viewController = CitySearchViewController(viewModel: viewModel)

        router.root = viewController
        
        route(to: viewController, as: transition)
    }
    
    func openCitySearch1() {
        openCitySearch1(with: PushTransition())
    }
    
}

extension ScreenRouter: WeatherRoute {}
