//
//  AppCoordinator.swift
//  Under The Weather
//
//  Created by Abel Demoz on 14/10/2023.
//

import UIKit

final class AppCoordinator: Coordinator {

    typealias Factory = WeatherCoordinatorFactory


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
        let navigator = BasicNavigator(navigationController: navigationController)
        let weatherCoordinator = factory.makeWeatherCoordinator(navigator: navigator)
        presentChild(weatherCoordinator, animated: true, onDismissed: nil)
    }
}
