//
//  LaunchScreenViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 06/05/2023.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundGradient()
        setupViews()
        
    }
    
    func setupViews() {
        view.backgroundColor = .blue
        let launch = LaunchScreenView()
        view.addSubview(launch.title)
        launch.title.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            launch.title.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            launch.title.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -150),
            launch.title.heightAnchor.constraint(equalToConstant: 50),
            launch.title.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        view.addSubview(launch.titleImage)
        launch.titleImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            launch.titleImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            launch.titleImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -270),
            launch.titleImage.heightAnchor.constraint(equalToConstant: 250),
            launch.titleImage.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    func setupBackgroundGradient() {
        let colorTop =  UIColor(red: 66.0/255.0, green: 179.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 3.0/255.0, green: 73.0/255.0, blue: 164.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
        
    }
}
