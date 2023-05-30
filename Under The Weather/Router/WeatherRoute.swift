//
//  WeatherRoute.swift
//  Under The Weather
//
//  Created by Matthew Lock on 30/05/2023.
//

import Foundation
import UIKit

protocol WeatherRoute {
    //func openWeather()
}

extension WeatherRoute where Self: MainRouter {
    
//    func openWeather(with transition: Transition) {
//        let router = ScreenRouter(rootTransition: transition)
//        let viewModel = MainViewModel(router: router)
//        let viewController = CitySearchViewController(viewModel: viewModel)
//        router.root = viewController
//        
//        route(to: viewController, as: transition)
//    }
//    
//    func openWeather() {
//        openWeather(with: PushTransition(isAnimated: true))
//    }
    
}

extension ScreenRouter: WeatherRoute {}
