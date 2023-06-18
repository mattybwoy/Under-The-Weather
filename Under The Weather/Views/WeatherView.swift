//
//  WeatherView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 02/06/2023.
//

import UIKit
import SwiftUI

class WeatherView: UIView {

    public var cityCollectionView = UIHostingController(rootView: AddCityCollectionView(cities: DataStorageService.sharedUserData.userCityObject))
    public var weatherTableView = UIHostingController(rootView: WeatherTableView())
    
    public override init(frame: CGRect) {
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addSubview(cityCollectionView.view)
        setupCityCollectionView()
        addSubview(weatherTableView.view)
        setupWeatherTableView()
    }
    
    func setupCityCollectionView() {
        cityCollectionView.view.translatesAutoresizingMaskIntoConstraints = false
        cityCollectionView.view.backgroundColor = .yellow
        NSLayoutConstraint.activate([
            cityCollectionView.view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            cityCollectionView.view.centerXAnchor.constraint(equalTo: centerXAnchor),
            cityCollectionView.view.heightAnchor.constraint(equalToConstant: 100),
            cityCollectionView.view.widthAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    func setupWeatherTableView() {
        weatherTableView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherTableView.view.topAnchor.constraint(equalTo: cityCollectionView.view.bottomAnchor),
            weatherTableView.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            weatherTableView.view.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
}
