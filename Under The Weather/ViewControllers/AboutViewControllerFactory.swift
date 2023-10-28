//
//  AboutViewControllerFactory.swift
//  Under The Weather
//
//  Created by Abel Demoz on 14/10/2023.
//

protocol AboutViewControllerFactory {
    func makeAboutViewController() -> AboutViewController
}

extension DependencyContainer: AboutViewControllerFactory {
    func makeAboutViewController() -> AboutViewController {
        AboutViewController()
    }
}
