//
//  LaunchScreenView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 06/05/2023.
//

import UIKit

protocol LaunchDelegate: AnyObject {
    func nextTapped()
}

final class LaunchScreenView: UIView {

    weak var delegate: LaunchDelegate?

    public init() {
        super.init(frame: CGRect())
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupBackgroundGradient()

        addSubview(titleImage)
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([titleImage.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     titleImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -270),
                                     titleImage.heightAnchor.constraint(equalToConstant: 250),
                                     titleImage.widthAnchor.constraint(equalToConstant: 250)])

        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([title.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -150),
                                     title.heightAnchor.constraint(equalToConstant: 50),
                                     title.widthAnchor.constraint(equalToConstant: 300)])

        addSubview(openingText)
        openingText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([openingText.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     openingText.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -60),
                                     openingText.heightAnchor.constraint(equalToConstant: 150),
                                     openingText.widthAnchor.constraint(equalToConstant: 270)])

        addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([nextButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 50),
                                     nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     nextButton.heightAnchor.constraint(equalToConstant: 50),
                                     nextButton.widthAnchor.constraint(equalToConstant: 100)])
    }

    private let title: UILabel = {
        let title = UILabel()
        title.textColor = UIColor(named: "TitleTextColor")
        title.text = "Under The Weather"
        title.font = UIFont(name: "ComicNeueSansID", size: 30)
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
        openingText.text = "Welcome, please provide your local city on the next screen"
        openingText.font = UIFont(name: "ComicNeueSansID", size: 18)
        openingText.textAlignment = .center
        openingText.numberOfLines = 0
        return openingText
    }()

    private let nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.backgroundColor = UIColor(named: "TitleTextColor")
        nextButton.titleLabel?.font = UIFont(name: "ComicNeueSansID", size: 20)
        nextButton.setTitle("Next", for: .normal)
        nextButton.layer.cornerRadius = 8
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return nextButton
    }()

    private func setupBackgroundGradient() {
        backgroundColor = .clear
        let colorTop = UIColor(red: 66.0 / 255.0, green: 179.0 / 255.0, blue: 210.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 3.0 / 255.0, green: 73.0 / 255.0, blue: 164.0 / 255.0, alpha: 1.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }

    @objc func nextTapped() {
        delegate?.nextTapped()
    }

}
