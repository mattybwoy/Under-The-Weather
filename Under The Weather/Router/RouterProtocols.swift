//
//  RouterProtocols.swift
//  Under The Weather
//
//  Created by Matthew Lock on 24/05/2023.
//

import UIKit

protocol Closable: AnyObject {
    func close()
}

protocol Dismissable: AnyObject {
    func dismiss()
}

protocol Routable: AnyObject {
    func route(to viewController: UIViewController, as transition: Transition)
}

protocol Transition: AnyObject {
    var isAnimated: Bool { get set }
    
    func open(_ viewController: UIViewController, from: UIViewController)
    func close(_ viewController: UIViewController)
}

protocol AnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    var isPresenting: Bool { get set }
}

protocol MainRouter: Routable {
    var root: UIViewController? { get set }
}
