//
//  WeatherRoute.swift
//  Under The Weather
//
//  Created by Matthew Lock on 30/05/2023.
//

import Foundation
import UIKit

protocol WeatherRoute {
    func addCity()
    func openAbout()
}

extension WeatherRoute where Self: MainRouter {
    
    func addCity(with transition: Transition) {
        let router = ScreenRouter(rootTransition: transition)
        let viewModel = CitySearchViewModel(router: router)
        let viewController = CitySearchViewController(viewModel: viewModel)
        router.root = viewController
        route(to: viewController, as: transition)
    }
    
    func openAbout(with transition: Transition) {
        let router = ScreenRouter(rootTransition: transition)
        let viewController = AboutViewController()
        if let sheet = viewController.presentationController as? UISheetPresentationController {
            sheet.preferredCornerRadius = 25
            sheet.detents = [.medium()]
        }
        router.root = viewController
        route(to: viewController, as: transition)
    }
    
    func addCity() {
        addCity(with: PushTransition())
    }
    
    func openAbout() {
        openAbout(with: ModalTransition())
    }
    
}

extension ScreenRouter: WeatherRoute {}
