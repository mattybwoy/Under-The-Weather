//
//  WeatherView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 02/06/2023.
//

import SwiftUI
import UIKit

protocol WeatherDelegate: AnyObject {
    func refreshCitiesTapped(_ sender: UIButton)
    func openAbout()
}

final class WeatherView: UIView {

    weak var viewModel: WeatherViewModel?
    weak var weatherVC: WeatherViewController?
    weak var delegate: WeatherDelegate?

    init(weatherVC: WeatherViewController, viewModel: WeatherViewModel) {
        self.weatherVC = weatherVC
        self.viewModel = viewModel
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        addSubview(cityWeatherView.view)
        setupCityWeatherView()
        setupButtons()
    }

    public lazy var cityWeatherView: UIHostingController<some View> = UIHostingController(rootView: CityWeatherView().environmentObject(weatherVC!).environmentObject(viewModel!))

    private func setupCityWeatherView() {
        cityWeatherView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([cityWeatherView.view.topAnchor.constraint(equalTo: topAnchor),
                                     cityWeatherView.view.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     cityWeatherView.view.widthAnchor.constraint(equalTo: widthAnchor)])
    }

    private var leftBarButton: UIButton {
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        var leftConfig = UIButton.Configuration.plain()
        leftConfig.image = UIImage(systemName: "arrow.clockwise", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        leftButton.configuration = leftConfig
        leftButton.addTarget(self, action: #selector(refresh(_:)), for: .touchUpInside)
        leftButton.tintColor = UIColor(named: "background2")
        return leftButton
    }

    private var rightBarButton: UIButton {
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        var rightConfig = UIButton.Configuration.plain()
        rightConfig.image = UIImage(systemName: "info.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        rightButton.configuration = rightConfig
        rightButton.addTarget(self, action: #selector(openAbout), for: .touchUpInside)
        rightButton.tintColor = UIColor(named: "background2")
        return rightButton
    }

    private func setupButtons() {
        let leftBarButton = UIBarButtonItem(customView: leftBarButton)
        weatherVC?.navigationItem.leftBarButtonItem = leftBarButton
        let rightBarButton = UIBarButtonItem(customView: rightBarButton)
        weatherVC?.navigationItem.rightBarButtonItem = rightBarButton

        weatherVC?.navigationItem.setHidesBackButton(true, animated: true)
    }

    @objc func refresh(_ sender: UIButton) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, animations: {
                sender.transform = CGAffineTransform(rotationAngle: .pi)
                sender.transform = CGAffineTransform(rotationAngle: .pi * 2)
            })
        }
        delegate?.refreshCitiesTapped(leftBarButton)
    }

    @objc func openAbout() {
        delegate?.openAbout()
    }

}
