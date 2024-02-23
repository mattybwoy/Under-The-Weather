//
//  WeatherViewControllerFactory.swift
//  Under The Weather
//
//  Created by Abel Demoz on 14/10/2023.
//

protocol WeatherViewControllerFactory {
    func makeWeatherViewController(navigationDelegate: WeatherNavigationDelegate, onDismissed: (() -> Void)?) -> WeatherViewController
}

extension DependencyContainer: WeatherViewControllerFactory {
    func makeWeatherViewController(navigationDelegate: WeatherNavigationDelegate, onDismissed: (() -> Void)?) -> WeatherViewController {
        let weatherViewModel = WeatherViewModel(navigationDelegate: navigationDelegate)
        let weatherViewController = WeatherViewController(viewModel: weatherViewModel)
        weatherViewController.onDismissed = onDismissed
        return weatherViewController
    }
}
