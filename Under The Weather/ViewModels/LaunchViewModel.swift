//
//  CitySearchViewModel.swift
//  Under The Weather
//
//  Created by Matthew Lock on 30/05/2023.
//

import Foundation

final class LaunchViewModel {
    typealias Routes = LaunchScreenRoute & Closable
    private var router: Routes
    
    init(router: Routes) {
        self.router = router
    }
    
    func nextButtonTapped() {
        router.openCitySearch()
    }
    
}
