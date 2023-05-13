//
//  LaunchScreen.swift
//  Under The Weather
//
//  Created by Matthew Lock on 06/05/2023.
//

import UIKit

class LaunchScreenView: UIView {
    
    public init() {
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBackgroundGradient()
        
        addSubview(titleImage)
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -270),
            titleImage.heightAnchor.constraint(equalToConstant: 250),
            titleImage.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -150),
            title.heightAnchor.constraint(equalToConstant: 50),
            title.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        addSubview(openingText)
        openingText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            openingText.centerXAnchor.constraint(equalTo: centerXAnchor),
            openingText.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -60),
            openingText.heightAnchor.constraint(equalToConstant: 150),
            openingText.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        addSubview(cityTextField)
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            cityTextField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 20),
            cityTextField.heightAnchor.constraint(equalToConstant: 50),
            cityTextField.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        addSubview(launchButton)
        launchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            launchButton.centerYAnchor.constraint(equalTo: cityTextField.centerYAnchor, constant: 80),
            launchButton.centerXAnchor.constraint(equalTo: cityTextField.centerXAnchor),
            launchButton.heightAnchor.constraint(equalToConstant: 50),
            launchButton.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private let title: UILabel = {
        let title = UILabel()
        title.textColor = UIColor(named: "TitleTextColor")
        title.text = "Under The Weather"
        title.font = .systemFont(ofSize: 30)
        title.textAlignment = .center
        return title
    }()
    
    private let titleImage: UIImageView = {
        let titleImage = UIImageView()
        titleImage.image = UIImage(named: "UnderTheWeatherTransparent")
        return titleImage
    }()
    
    private let openingText: UILabel = {
        let openingText = UILabel()
        openingText.textColor = UIColor(named: "TitleTextColor")
        openingText.text = "Please provide your local city"
        openingText.font = .systemFont(ofSize: 20)
        openingText.textAlignment = .center
        openingText.numberOfLines = 0
        return openingText
    }()
    
    public let cityTextField: UITextField = {
        let cityTextField = UITextField()
        cityTextField.backgroundColor = .white
        cityTextField.borderStyle = .roundedRect
        return cityTextField
    }()
    
    public let launchButton: UIButton = {
        let launchButton = UIButton()
        launchButton.backgroundColor = UIColor(named: "TitleTextColor")
        launchButton.setTitle("Go", for: .normal)
        launchButton.layer.cornerRadius = 8
        return launchButton
    }()
    
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
