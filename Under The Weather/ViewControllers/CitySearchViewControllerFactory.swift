//
//  CitySearchViewControllerFactory.swift
//  Under The Weather
//
//  Created by Abel Demoz on 14/10/2023.
//

protocol CitySearchViewControllerFactory {
    func makeCitySearchViewController(navigationDelegate: CitySearchNavigationDelegate) -> CitySearchViewController
}

extension DependencyContainer: CitySearchViewControllerFactory {
    func makeCitySearchViewController(navigationDelegate: CitySearchNavigationDelegate) -> CitySearchViewController {
        let viewModel = CitySearchViewModel(navigationDelegate: navigationDelegate)
        return CitySearchViewController(viewModel: viewModel)
    }
}
