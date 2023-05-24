//
//  InitialUserRoute.swift
//  Under The Weather
//
//  Created by Matthew Lock on 24/05/2023.
//

import Foundation
import UIKit

protocol InitialUserRoute {
    func openCitySearch()
}

extension InitialUserRoute where Self: MainRouter {
    
    func openCitySearch(with transition: Transition) {
        //let modal = ModalTransition()
        let router = ScreenRouter(rootTransition: transition)
        let viewController = InitialSearchViewController()
        router.root = viewController
        
        route(to: viewController, as: transition)
    }
    func openCitySearch() {
        openCitySearch(with: ModalTransition())
    }
}

extension ScreenRouter: InitialUserRoute {}
