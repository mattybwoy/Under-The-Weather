//
//  MainRouterProtocol.swift
//  Under The Weather
//
//  Created by Matthew Lock on 24/05/2023.
//

import UIKit

class ScreenRouter: MainRouter, Closable, Dismissable {
    
    private let rootTransition: Transition
    weak var root: UIViewController?
    
    init(rootTransition: Transition) {
        self.rootTransition = rootTransition
    }
    
    func close() {
        guard let root = root else { return }
        rootTransition.close(root)
    }
    
    func dismiss() {
        guard let root = root else { return }
        root.dismiss(animated: rootTransition.isAnimated)
    }
    
    func route(to viewController: UIViewController, as transition: Transition) {
        guard let root = root else { return }
        transition.open(viewController, from: root)
    }
    
    
}
