//
//  LaunchScreenRoute.swift
//  Under The Weather
//
//  Created by Matthew Lock on 24/05/2023.
//

import Foundation
import UIKit

protocol LaunchScreenRoute {
    func openCitySearch()
}

extension LaunchScreenRoute where Self: MainRouter {

    // it doesn't look like this method is needed? You can put it in the
    // body of `openCitySearch`
    func openCitySearch(with transition: Transition) {
        let router = ScreenRouter(rootTransition: transition)
        let viewModel = CitySearchViewModel(router: router)
        let viewController = CitySearchViewController(viewModel: viewModel)
        router.root = viewController
        
        route(to: viewController, as: transition)
    }
    
    func openCitySearch() {
        openCitySearch(with: PushTransition())

        /*
         let transition = PushTransition()
         let router = ScreenRouter(rootTransition: transition)
         let viewModel = CitySearchViewModel(router: router)
         let viewController = CitySearchViewController(viewModel: viewModel)
         router.root = viewController

         route(to: viewController, as: transition)
         */
    }
    
}

extension ScreenRouter: LaunchScreenRoute {}
