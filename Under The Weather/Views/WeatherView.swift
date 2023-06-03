//
//  WeatherView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 02/06/2023.
//

import UIKit
import SwiftUI

class WeatherView: UIView {

    public var cityCollectionView = UIHostingController(rootView: AddCityCollectionView())
    
    public override init(frame: CGRect) {
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addSubview(cityCollectionView.view)
        setupCityCollectionView()
    }
    
    func setupCityCollectionView() {
        cityCollectionView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityCollectionView.view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            cityCollectionView.view.centerXAnchor.constraint(equalTo: centerXAnchor),
            cityCollectionView.view.heightAnchor.constraint(equalToConstant: 70),
            cityCollectionView.view.widthAnchor.constraint(equalToConstant: 350)
        ])
        
    }
}
