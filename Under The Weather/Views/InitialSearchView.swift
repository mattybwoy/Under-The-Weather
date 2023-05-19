//
//  InitialSearchView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 19/05/2023.
//

import UIKit

class InitialSearchView: UIView {
    
    public init() {
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBackgroundGradient()
    }
    
    func setupBackgroundGradient() {
        backgroundColor = .clear
        let colorTop =  UIColor(red: 66.0/255.0, green: 179.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 3.0/255.0, green: 73.0/255.0, blue: 164.0/255.0, alpha: 1.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }

}
