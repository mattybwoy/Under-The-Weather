//
//  ModalTransition.swift
//  Under The Weather
//
//  Created by Matthew Lock on 24/05/2023.
//

import UIKit

final class ModalTransition: NSObject {
    var isAnimated: Bool = true
    
    var modalTransitionStyle: UIModalTransitionStyle
    var modalPresentationStyle: UIModalPresentationStyle

    init(isAnimated: Bool = true,
         modalTransitionStyle: UIModalTransitionStyle = .coverVertical,
         modalPresentationStyle: UIModalPresentationStyle = .automatic) {
        self.isAnimated = isAnimated
        self.modalTransitionStyle = modalTransitionStyle
        self.modalPresentationStyle = modalPresentationStyle
    }
}

extension ModalTransition: Transition {

    
    // MARK: - Transition

    func open(_ viewController: UIViewController, from: UIViewController) {
        viewController.modalPresentationStyle = modalPresentationStyle
        viewController.modalTransitionStyle = modalTransitionStyle
        from.present(viewController, animated: isAnimated)
    }

    func close(_ viewController: UIViewController) {
        viewController.dismiss(animated: isAnimated)
    }
}
