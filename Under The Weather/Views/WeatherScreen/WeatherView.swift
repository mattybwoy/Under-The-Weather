//
//  WeatherView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 02/06/2023.
//

import UIKit
import SwiftUI

class WeatherView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addSubview(cityWeatherView.view)
        setupCityWeatherView()
    }
    
    public var cityWeatherView: UIHostingController <some View> = UIHostingController(rootView: CityWeatherView().environmentObject(DataStorageService.sharedUserData)
        .environmentObject(WeatherViewController(viewModel: WeatherViewModel(router: ScreenRouter(rootTransition: EmptyTransition())))))
    
    func setupCityWeatherView() {
        cityWeatherView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityWeatherView.view.topAnchor.constraint(equalTo: topAnchor),
            cityWeatherView.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            cityWeatherView.view.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }

}
