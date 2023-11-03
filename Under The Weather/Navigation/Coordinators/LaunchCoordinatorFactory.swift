//
//  LaunchCoordinatorFactory.swift
//  Under The Weather
//
//  Created by Matthew Lock on 02/11/2023.
//

import Foundation

protocol LaunchCoordinatorFactory {
    func makeLaunchCoordinator(navigator: Navigator) -> Coordinator
}

extension DependencyContainer: LaunchCoordinatorFactory {
    func makeLaunchCoordinator(navigator: Navigator) -> Coordinator {
        LaunchCoordinator(navigator: navigator, factory: self)
    }
}
