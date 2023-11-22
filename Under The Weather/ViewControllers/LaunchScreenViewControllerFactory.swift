//
//  LaunchScreenViewControllerFactory.swift
//  Under The Weather
//
//  Created by Matthew Lock on 02/11/2023.
//

import Foundation

protocol LaunchScreenViewControllerFactory {
    func makeLaunchScreenViewController(navigationDelegate: LaunchNavigationDelegate, onDismissed: (() -> Void)?) -> LaunchScreenViewController
}

extension DependencyContainer: LaunchScreenViewControllerFactory {
    func makeLaunchScreenViewController(navigationDelegate: LaunchNavigationDelegate, onDismissed: (() -> Void)?) -> LaunchScreenViewController {
        let launchViewModel = LaunchViewModel(navigationDelegate: navigationDelegate)
        let launchScreenViewController = LaunchScreenViewController(viewModel: launchViewModel)
        launchScreenViewController.onDismissed = onDismissed
        return launchScreenViewController
    }
}
