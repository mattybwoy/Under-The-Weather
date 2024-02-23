//
//  CitySearchCoordinator.swift
//  Under The Weather
//
//  Created by Abel Demoz on 14/10/2023.
//

import Compass
import UIKit

final class CitySearchCoordinator: Coordinator {

    typealias Factory = CitySearchViewControllerFactory

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
        let viewController: ViewController = factory.makeCitySearchViewController(navigationDelegate: self, onDismissed: onDismissed)
        baseViewController = viewController
        switch transition {
        case .push:
            navigator.navigate(to: viewController, transition: transition)
        case .modal:
            let navController = BasicNavigationController(rootViewController: viewController)
            navigator.navigate(to: navController, transition: transition)
        }
    }
}

extension CitySearchCoordinator: CitySearchNavigationDelegate {

    func didTapCitySearchPrimaryCTA() {
        finish(animated: true)
    }
}
