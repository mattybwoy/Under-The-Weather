//
//  LaunchCoordinator.swift
//  Under The Weather
//
//  Created by Matthew Lock on 02/11/2023.
//

import Compass
import UIKit

final class LaunchCoordinator: Coordinator {

    typealias Factory = CitySearchViewControllerFactory
        & LaunchScreenViewControllerFactory
        & WeatherCoordinatorFactory

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
        let viewController: ViewController = factory.makeLaunchScreenViewController(navigationDelegate: self, onDismissed: onDismissed)
        baseViewController = viewController
        navigator.navigate(to: viewController, transition: transition)
    }
}

extension LaunchCoordinator: LaunchNavigationDelegate, CitySearchNavigationDelegate {

    func nextButtonTapped() {
        let viewController = factory.makeCitySearchViewController(navigationDelegate: self, onDismissed: nil)
        navigator.navigate(to: viewController, transition: .push(animated: true))
    }

    func didTapCitySearchPrimaryCTA() {
        let weatherCoordinator = factory.makeWeatherCoordinator(navigator: navigator)
        startChild(weatherCoordinator, transition: .push(animated: true), onDismissed: nil)
    }

}
