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
    WeatherViewControllerFactory &
    AboutViewControllerFactory
    
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

extension LaunchCoordinator: LaunchNavigationDelegate, CitySearchNavigationDelegate, WeatherNavigationDelegate {
    func addCityTapped() {
        //
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
    
    
    func nextButtonTapped() {
        let viewController = factory.makeCitySearchViewController(navigationDelegate: self)
        navigator.present(viewController,
                          presentation: .push(animated: true),
                          onDismissed: nil)
    }
    
    func didDismiss(viewController: UIViewController) {
        //
    }
    
    func citySelectionNextTapped() {
        let viewController = factory.makeWeatherViewController(navigationDelegate: self)
        navigator.present(viewController,
                          presentation: .push(animated: true),
                          onDismissed: nil)
    }
    
}
