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
        
    }
}
