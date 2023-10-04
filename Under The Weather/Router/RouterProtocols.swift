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

// The `Transition` type should describe the transition between VCs (e.g. animation speed,
// modal or not etc). It shouldn't do any pushing or popping. Consider creating a `Navigator`
// protocol and having a concrete navigator type conform to that protocol. This concrete type
// should do all of the pushing and popping. Furthermore, the `Transition` type can be an
// enum with cases for push, modal etc. These cases can have associated values for animation
// and stuff. The `Navigator` methods should then take values of type `Transition` as parameters
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
