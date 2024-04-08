//
//  WeatherCoordinator.swift
//  Under The Weather
//
//  Created by Abel Demoz on 14/10/2023.
//

import Compass
import UIKit

final class WeatherCoordinator: Coordinator, CitySearchNavigationDelegate {
    func didTapCitySearchPrimaryCTA() {
        navigator.dismiss(animated: true)
    }

    typealias Factory = WeatherViewControllerFactory
        & CitySearchCoordinatorFactory
        & AboutViewControllerFactory

    var childCoordinators: [Coordinator] = []

    let navigator: Navigator
    let factory: Factory
    weak var baseViewController: ViewController?
    unowned var parentCoordinator: Coordinator?

    init(navigator: Navigator, factory: Factory) {
        self.navigator = navigator
        self.factory = factory
    }

    func start(transition: Transition, onDismissed: (() -> Void)?) {
        let viewController: ViewController = factory.makeWeatherViewController(navigationDelegate: self, onDismissed: onDismissed)
        baseViewController = viewController
        navigator.navigate(to: viewController, transition: transition)
    }
}

extension WeatherCoordinator: WeatherNavigationDelegate {

    func addCityTapped() {
        let coordinator = factory.makeCitySearchCoordinator(navigator: navigator)
        startChild(coordinator, transition: .modal(animated: true), onDismissed: nil)
    }

    func aboutTapped() {
        let viewController: ViewController = factory.makeAboutViewController(onDismissed: nil)
        baseViewController = viewController

        if let sheet = viewController.sheetPresentationController {
            sheet.preferredCornerRadius = 25
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }

        navigator.navigate(to: viewController,
                           transition: .modal(animated: true))
    }

}
