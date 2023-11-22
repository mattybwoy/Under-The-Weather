//
//  AboutViewControllerFactory.swift
//  Under The Weather
//
//  Created by Abel Demoz on 14/10/2023.
//

protocol AboutViewControllerFactory {
    func makeAboutViewController(onDismissed: (() -> Void)?) -> AboutViewController
}

extension DependencyContainer: AboutViewControllerFactory {
    func makeAboutViewController(onDismissed: (() -> Void)?) -> AboutViewController {
        let viewController = AboutViewController()
        viewController.onDismissed = onDismissed
        return viewController
    }
}
