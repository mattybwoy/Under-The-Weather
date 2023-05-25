//
//  CitySearchRoute.swift
//  Under The Weather
//
//  Created by Matthew Lock on 24/05/2023.
//

import Foundation
import UIKit

protocol CitySearchRoute {
    func openCitySearch()
}

extension CitySearchRoute where Self: MainRouter {
    
    func openCitySearch(with transition: Transition) {
        let router = ScreenRouter(rootTransition: transition)
        let viewController = CitySearchViewController()
        router.root = viewController
        
        route(to: viewController, as: transition)
    }
    
    func openCitySearch() {
        openCitySearch(with: ModalTransition())
    }
    
}

extension ScreenRouter: CitySearchRoute {}
