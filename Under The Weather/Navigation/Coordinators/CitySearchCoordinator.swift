//
//  CitySearchCoordinator.swift
//  Under The Weather
//
//  Created by Abel Demoz on 14/10/2023.
//

import UIKit

final class CitySearchCoordinator: Coordinator {

    typealias Factory = CitySearchViewControllerFactory

    var childCoordinators: [Coordinator] = []

    let navigator: Navigator
    let factory: Factory

    init(navigator: Navigator, factory: Factory, p: Presentation = .push(animated: true)) {
        self.navigator = navigator
        self.factory = factory
    }

    func start(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = factory.makeCitySearchViewController(navigationDelegate: self)
        navigator.present(
            viewController,
            presentation: .modal(animated: true),
            onDismissed: onDismissed
        )
    }
}

extension CitySearchCoordinator: CitySearchNavigationDelegate {
    func didDismiss(viewController: UIViewController) {
        navigator.dismiss(viewController: viewController, animated: true)
    }

    func nextButtonTapped() {
        navigator.dismiss(animated: true)
    }
}

