//
//  WeatherViewControllerFactory.swift
//  Under The Weather
//
//  Created by Abel Demoz on 14/10/2023.
//

protocol WeatherViewControllerFactory {
    func makeWeatherViewController(navigationDelegate: WeatherNavigationDelegate) -> WeatherViewController
}

extension DependencyContainer: WeatherViewControllerFactory {
    func makeWeatherViewController(navigationDelegate: WeatherNavigationDelegate) -> WeatherViewController {
        let weatherViewModel = WeatherViewModel(navigationDelegate: navigationDelegate)
        let weatherViewController = WeatherViewController(viewModel: weatherViewModel)
        return weatherViewController
    }
}
