//
//  WeatherViewModel.swift
//  Under The Weather
//
//  Created by Matthew Lock on 30/05/2023.
//

import Foundation
import UIKit

protocol CitySearchNavigationDelegate {
    func nextButtonTapped()
    func didDismiss(viewController: UIViewController)
}

struct CitySearchViewModel {

    let navigationDelegate: CitySearchNavigationDelegate
    
    func nextButtonTapped() {
        navigationDelegate.nextButtonTapped()
    }
    
    func throwAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }

    func didDismiss(viewController: UIViewController) {
        navigationDelegate.didDismiss(viewController: viewController)
    }
}
