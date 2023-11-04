//
//  WeatherCoordinator.swift
//  Under The Weather
//
//  Created by Abel Demoz on 14/10/2023.
//

import UIKit

final class WeatherCoordinator: Coordinator {

    typealias Factory = WeatherViewControllerFactory
    & CitySearchViewControllerFactory
    & AboutViewControllerFactory

    var childCoordinators: [Coordinator] = []

    let navigator: Navigator
    let factory: Factory

    init(navigator: Navigator, factory: Factory) {
        self.navigator = navigator
        self.factory = factory
    }

    func start(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = factory.makeWeatherViewController(navigationDelegate: self)
        let presentation = Presentation.push(animated: true)
        navigator.present(
            viewController,
            presentation: presentation,
            onDismissed: onDismissed
        )
    }
}

extension WeatherCoordinator: WeatherNavigationDelegate, CitySearchNavigationDelegate {
    func citySelectionNextTapped() {
        navigator.dismiss(animated: true)
    }
    
    func didDismiss(viewController: UIViewController) {
        //
    }
    

    func addCityTapped() {
        let viewController = factory.makeCitySearchViewController(navigationDelegate: self)
        navigator.present(viewController, presentation: .push(animated: true), onDismissed: nil)
    }

    func aboutTapped() {
        let viewController = factory.makeAboutViewController()

        if let sheet = viewController.presentationController as? UISheetPresentationController {
            sheet.preferredCornerRadius = 25
            sheet.detents = [.medium()]
        }

        navigator.present(
            viewController,
            presentation: .modal(animated: true),
            onDismissed: nil
        )
    }
}
