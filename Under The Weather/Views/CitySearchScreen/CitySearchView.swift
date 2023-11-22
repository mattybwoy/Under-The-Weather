//
//  CitySearchView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 19/05/2023.
//

import UIKit

protocol CityDelegate: AnyObject {
    func nextButtonTapped()
}

final class CitySearchView: UIView {

    weak var delegate: CityDelegate?

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
        addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -270),
            searchBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.widthAnchor.constraint(equalToConstant: 300)
        ])

        addSubview(resultsTable)
        resultsTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultsTable.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 30),
            resultsTable.centerXAnchor.constraint(equalTo: centerXAnchor),
            resultsTable.heightAnchor.constraint(equalToConstant: 500),
            resultsTable.widthAnchor.constraint(equalToConstant: 300)
        ])

        addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: resultsTable.bottomAnchor, constant: 30),
            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.widthAnchor.constraint(equalToConstant: 100)
        ])

        resultsTable.register(CitySearchTableViewCell.self, forCellReuseIdentifier: CitySearchTableViewCell.reuseIdentifier)
    }

    private func setupBackgroundGradient() {
        let colorTop = UIColor(red: 66 / 255, green: 179 / 255, blue: 210 / 255, alpha: 1).cgColor
        let colorBottom = UIColor(red: 3 / 255, green: 73 / 255, blue: 164 / 255, alpha: 1).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }

    public let searchBar: UISearchBar = {
        var bar = UISearchBar()
        bar.searchTextField.textColor = .white
        bar.layer.cornerRadius = 8
        bar.tintColor = .white
        bar.barTintColor = .white
        bar.searchTextField.layer.cornerRadius = 10
        bar.searchTextField.layer.masksToBounds = true
        bar.backgroundImage = UIImage()
        bar.backgroundColor = UIColor(red: 55 / 255, green: 160 / 255, blue: 202 / 255, alpha: 1)
        bar.searchTextField.font = UIFont(name: "ComicNeueSansID", size: 18)
        let textField = bar.value(forKey: "searchField") as! UITextField

        let glassIconView = textField.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        glassIconView.tintColor = UIColor.white
        let clearButton = textField.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: [])
        clearButton.tintColor = UIColor.white
        bar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        return bar
    }()

    public let resultsTable: UITableView = {
        var resultsTable = UITableView()
        resultsTable.layer.cornerRadius = 20
        resultsTable.layer.borderColor = UIColor.systemYellow.cgColor
        resultsTable.layer.borderWidth = 2
        resultsTable.rowHeight = 50
        return resultsTable
    }()

    private let nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.backgroundColor = UIColor(named: "TitleTextColor")
        nextButton.titleLabel?.font = UIFont(name: "ComicNeueSansID", size: 20)
        nextButton.setTitle("Next", for: .normal)
        nextButton.layer.cornerRadius = 8
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return nextButton
    }()

    @objc func nextButtonTapped() {
        delegate?.nextButtonTapped()
    }
}
