//
//  BasicNavigator.swift
//  Under The Weather
//
//  Created by Abel Demoz on 14/10/2023.
//

import UIKit

final class BasicNavigator: NSObject {
    private let navigationController: UINavigationController
    private(set) var rootViewController: UIViewController?
    private(set) var onDismissForViewController: [UIViewController: () -> Void] = [:]

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        rootViewController = navigationController.viewControllers.first
        super.init()

        self.navigationController.delegate = self
    }
}

extension BasicNavigator: Navigator {
    func present(_ viewController: UIViewController, presentation: Presentation, onDismissed: (() -> Void)?) {
        onDismissForViewController[viewController] = onDismissed

        switch presentation {
        case let .push(animated):
            navigationController.pushViewController(viewController, animated: animated)
        case let .modal(animated, presentationStyle, transitionStyle):
            viewController.modalPresentationStyle = presentationStyle
            viewController.modalTransitionStyle = transitionStyle
            navigationController.present(viewController, animated: animated)
        }

        setRootViewController()
    }

    func dismiss(animated: Bool) {
        guard let rootViewController else {
            navigationController.popToRootViewController(animated: animated)
            return
        }
        performOnDismissed(for: rootViewController)
        navigationController.popToViewController(rootViewController, animated: animated)
    }

    private func performOnDismissed(for viewController: UIViewController) {
        guard let onDismiss = onDismissForViewController[viewController] else {
            return
        }

        onDismiss()
        onDismissForViewController[viewController] = nil
    }

    private func setRootViewController() {
        guard navigationController.viewControllers.first != nil && rootViewController == nil else {
            return
        }

        rootViewController = navigationController.viewControllers.first
    }
}

extension BasicNavigator: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        guard
            let dismissedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(dismissedViewController)
        else {
            return
        }
        performOnDismissed(for: dismissedViewController)
    }
}
