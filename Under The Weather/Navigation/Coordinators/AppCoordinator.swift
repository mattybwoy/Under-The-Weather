//
//  AppCoordinator.swift
//  Under The Weather
//
//  Created by Abel Demoz on 14/10/2023.
//

import Compass
import UIKit

final class AppCoordinator: Coordinator {

    typealias Factory = LaunchCoordinatorFactory & WeatherCoordinatorFactory

    var childCoordinators: [Coordinator] = []

    unowned let navigator: Navigator
    let factory: Factory
    weak var baseViewController: ViewController?
    unowned var parentCoordinator: Coordinator?

    init(navigator: Navigator, factory: Factory) {
        self.navigator = navigator
        self.factory = factory
    }

    func start(transition: Transition, onDismissed: (() -> Void)?) {
        let navigationController = BasicNavigationController()
        navigator.navigate(to: navigationController, transition: transition)

        if seenOnboarding {
            let navigator = BasicNavigator(navigationController: navigationController)
            let weatherCoordinator = factory.makeWeatherCoordinator(navigator: navigator)
            startChild(weatherCoordinator, transition: .push(animated: true), onDismissed: nil)
        } else {
            let navigator = BasicNavigator(navigationController: navigationController)
            let launchCoordinator = factory.makeLaunchCoordinator(navigator: navigator)
            startChild(launchCoordinator, transition: transition, onDismissed: nil)
        }
    }
}

extension AppCoordinator {

    private var seenOnboarding: Bool {
        return UserDefaults.hasSeenAppIntroduction
    }

}
