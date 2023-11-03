//
//  LaunchCoordinator.swift
//  Under The Weather
//
//  Created by Matthew Lock on 02/11/2023.
//

import Foundation

final class LaunchCoordinator: Coordinator {
    
    typealias Factory = CitySearchViewControllerFactory
    
    var childCoordinators: [Coordinator] = []
    
    let navigator: Navigator
    let factory: Factory
    
    init(navigator: Navigator, factory: Factory) {
        self.navigator = navigator
        self.factory = factory
    }
    
    func start(animated: Bool, onDismissed: (() -> Void)?) {
        
    }
    
    
}
