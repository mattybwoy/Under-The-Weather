//
//  AppCoordinator.swift
//  Under The Weather
//
//  Created by Abel Demoz on 14/10/2023.
//

import UIKit

final class AppCoordinator: Coordinator {

    typealias Factory = WeatherCoordinatorFactory & LaunchCoordinatorFactory

    var childCoordinators: [Coordinator] = []
    let navigator: Navigator
    let factory: Factory

    init(navigator: Navigator, factory: Factory) {
        self.navigator = navigator
        self.factory = factory
    }

    func start(animated: Bool, onDismissed: (() -> Void)?) {
        let navigationController = UINavigationController()
        navigator.present(
            navigationController,
            presentation: .push(animated: true),
            onDismissed: nil
        )
        if seenOnboarding {
            let navigator = BasicNavigator(navigationController: navigationController)
            let weatherCoordinator = factory.makeWeatherCoordinator(navigator: navigator)
            presentChild(weatherCoordinator, animated: true, onDismissed: nil)
        } else {
            let navigator = BasicNavigator(navigationController: navigationController)
            let launchCoordinator = factory.makeLaunchCoordinator(navigator: navigator)
            presentChild(launchCoordinator, animated: true, onDismissed: nil)
        }

    }
}

extension AppCoordinator {
    
    private var seenOnboarding: Bool {
        return UserDefaults.hasSeenAppIntroduction
    }
    
}
