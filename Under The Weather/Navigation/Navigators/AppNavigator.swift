//
//  AppNavigator.swift
//  Under The Weather
//
//  Created by Abel Demoz on 14/10/2023.
//

import UIKit

final class AppNavigator: Navigator {
    func dismiss(viewController: UIViewController, animated: Bool) {
        //
    }


    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func present(_ viewController: UIViewController, presentation: Presentation, onDismissed: (() -> Void)?) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }

    func dismiss(animated: Bool) {
        fatalError("AppNavigator should never dismiss")
    }


}
