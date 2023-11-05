//
//  LaunchCoordinator.swift
//  Under The Weather
//
//  Created by Matthew Lock on 02/11/2023.
//

import UIKit

final class LaunchCoordinator: Coordinator {
    
    typealias Factory = LaunchScreenViewControllerFactory &
    CitySearchViewControllerFactory &
    WeatherCoordinatorFactory
    
    var childCoordinators: [Coordinator] = []
    
    let navigator: Navigator
    let factory: Factory
    
    init(navigator: Navigator, factory: Factory) {
        self.navigator = navigator
        self.factory = factory
    }
    
    func start(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = factory.makeLaunchScreenViewController(navigationDelegate: self)
        let presentation = Presentation.push(animated: true)
        navigator.present(
            viewController,
            presentation: presentation,
            onDismissed: onDismissed
        )
    }
    
    
}

extension LaunchCoordinator: LaunchNavigationDelegate, CitySearchNavigationDelegate {
    func didDismiss(viewController: UIViewController) {
    }
    
    func nextButtonTapped() {
        let viewController = factory.makeCitySearchViewController(navigationDelegate: self)
        navigator.present(viewController,
                          presentation: .push(animated: true),
                          onDismissed: nil)
    }
    
    func citySelectionNextTapped() {
        let weatherCoordinator = factory.makeWeatherCoordinator(navigator: navigator)
        presentChild(weatherCoordinator, animated: true, onDismissed: nil)
    }
    
}
