//
//  CitySearchCoordinatorFactory.swift
//  Under The Weather
//
//  Created by Abel Demoz on 14/10/2023.
//

import UIKit

protocol CitySearchCoordinatorFactory {
    func makeCitySearchCoordinator(navigator: Navigator) -> Coordinator
}

extension DependencyContainer: CitySearchCoordinatorFactory {
    func makeCitySearchCoordinator(navigator: Navigator) -> Coordinator {
        CitySearchCoordinator(navigator: navigator, factory: self)
    }
}
