//
//  Coordinator.swift
//  Under The Weather
//
//  Created by Matthew Lock on 24/05/2023.
//

import UIKit

protocol Coordinator: AnyObject {

    var childCoordinators: [Coordinator] { get set }
    var navigator: Navigator { get }

    func dismiss(animated: Bool)
    func start(animated: Bool, onDismissed: (() -> Void)?)
    func presentChild(_ child: Coordinator, animated: Bool, onDismissed: (() -> Void)?)
}

extension Coordinator {

    func dismiss(animated: Bool) {
        navigator.dismiss(animated: animated)
    }

    func presentChild(_ child: Coordinator, animated: Bool, onDismissed: (() -> Void)?) {
        childCoordinators.append(child)
        child.start(animated: animated, onDismissed: { [weak self, weak child] in
            guard let self, let child else { return }

            self.removeChild(child)
            onDismissed?()
        })
    }

    private func removeChild(_ child: Coordinator) {
        guard let index = childCoordinators.firstIndex(where: { $0 === child }) else {
            return
        }

        childCoordinators.remove(at: index)
    }
}
