//
//  WeatherViewModel.swift
//  Under The Weather
//
//  Created by Matthew Lock on 30/05/2023.
//

import Foundation
import UIKit

final class CitySearchViewModel: ViewModelProtocol {
    
    typealias Routes = CitySearchRoute & Closable
    var router: Routes
    
    init(router: Routes) {
        self.router = router
    }
    
    func nextButtonTapped() {
        router.openWeather()
    }
    
    func closeModal() {
        router.close()
    }
    
    func throwAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
}
