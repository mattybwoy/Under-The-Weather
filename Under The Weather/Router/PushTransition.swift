//
//  PushTransition.swift
//  Under The Weather
//
//  Created by Matthew Lock on 24/05/2023.
//

import UIKit

final class PushTransition: NSObject {
    var isAnimated: Bool = true

    private weak var from: UIViewController?
    private var openCompletionHandler: (() -> Void)?
    private var closeCompletionHandler: (() -> Void)?

    private var navigationController: UINavigationController? {
        guard let navigation = from as? UINavigationController else { return from?.navigationController }
        return navigation
    }

    init(isAnimated: Bool = true) {
        self.isAnimated = isAnimated
    }
}

extension PushTransition: Transition {
    // MARK: - Transition
    
    func open(_ viewController: UIViewController, from: UIViewController) {
        self.from = from
        navigationController?.delegate = self
        navigationController?.pushViewController(viewController, animated: isAnimated)
    }

    func close(_ viewController: UIViewController) {
        navigationController?.popViewController(animated: isAnimated)
    }
}

extension PushTransition: UINavigationControllerDelegate {
    // MARK: - UINavigationControllerDelegate

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let transitionCoordinator = navigationController.transitionCoordinator,
            let fromVC = transitionCoordinator.viewController(forKey: .from),
            let toVC = transitionCoordinator.viewController(forKey: .to) else { return }

        // you should probably be using the === operator here instead. You want to
        // ensure that you're referring to the same instance in memory
        if fromVC == from {
            openCompletionHandler?()
            openCompletionHandler = nil
        } else if toVC == from {
            closeCompletionHandler?()
            closeCompletionHandler = nil
        }
    }
}
