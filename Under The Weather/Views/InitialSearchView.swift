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
        addSubview(searchBar)
        searchBar.sizeToFit()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -270),
            searchBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.widthAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    func setupBackgroundGradient() {
        let colorTop =  UIColor(red: 66.0/255.0, green: 179.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 3.0/255.0, green: 73.0/255.0, blue: 164.0/255.0, alpha: 1.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    let searchBar: UISearchBar = {
        var bar = UISearchBar()
        bar.placeholder = "Search"
        bar.searchTextField.textColor = .white
        bar.layer.cornerRadius = 8
        bar.searchTextField.layer.cornerRadius = 20
        bar.searchTextField.layer.masksToBounds = true
        bar.backgroundImage = UIImage()
        bar.backgroundColor = UIColor(red: 55/255, green: 160/255, blue: 202/255, alpha: 1.0)
        return bar
    }()

}
