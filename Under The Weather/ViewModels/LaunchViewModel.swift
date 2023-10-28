//
//  CitySearchViewModel.swift
//  Under The Weather
//
//  Created by Matthew Lock on 30/05/2023.
//

import Foundation

protocol LaunchNavigationDelegate: AnyObject {
    func onCitySelected()
}

final class LaunchViewModel {

    unowned var navigationDelegate: LaunchNavigationDelegate

    init(navigationDelegate: LaunchNavigationDelegate) {
        self.navigationDelegate = navigationDelegate
    }
    
    func nextButtonTapped() {
//        router.openCitySearch()
        navigationDelegate.onCitySelected()
    }
    
}
