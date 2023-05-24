//
//  EmptyTransition.swift
//  Under The Weather
//
//  Created by Matthew Lock on 24/05/2023.
//

import UIKit

final class EmptyTransition {
    var isAnimated: Bool = true
}

extension EmptyTransition: Transition {
    
    // MARK: - Transition

    func open(_ viewController: UIViewController, from: UIViewController) {}
    func close(_ viewController: UIViewController) {}
}
