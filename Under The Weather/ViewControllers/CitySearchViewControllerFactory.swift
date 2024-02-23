//
//  CitySearchViewControllerFactory.swift
//  Under The Weather
//
//  Created by Abel Demoz on 14/10/2023.
//

protocol CitySearchViewControllerFactory {
    func makeCitySearchViewController(navigationDelegate: CitySearchNavigationDelegate, onDismissed: (() -> Void)?) -> CitySearchViewController
}

extension DependencyContainer: CitySearchViewControllerFactory {
    func makeCitySearchViewController(navigationDelegate: CitySearchNavigationDelegate, onDismissed: (() -> Void)?) -> CitySearchViewController {
        let viewModel = CitySearchViewModel(navigationDelegate: navigationDelegate)
        let viewController = CitySearchViewController(viewModel: viewModel)
        viewController.onDismissed = onDismissed
        return viewController
    }
}
