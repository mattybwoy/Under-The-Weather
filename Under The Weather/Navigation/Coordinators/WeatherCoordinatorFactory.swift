//
//  WeatherCoordinatorFactory.swift
//  Under The Weather
//
//  Created by Abel Demoz on 14/10/2023.
//

import Compass

protocol WeatherCoordinatorFactory {
    func makeWeatherCoordinator(navigator: Navigator) -> Coordinator
}

extension DependencyContainer: WeatherCoordinatorFactory {
    func makeWeatherCoordinator(navigator: Navigator) -> Coordinator {
        WeatherCoordinator(navigator: navigator, factory: self)
    }
}
