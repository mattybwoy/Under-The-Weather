//
//  WeatherViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 29/04/2023.
//

import UIKit

final class WeatherViewController: GenericViewController <WeatherView>, ObservableObject, WeatherDelegate {

    private let viewModel: WeatherViewModel

    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchWeather()
        navigationController?.navigationBar.tintColor = UIColor(named: "background2")
        rootView.delegate = self
    }
    
    override func loadView() {

        self.view = WeatherView(weatherVC: self)
    }

    func addCitytapped() {
        viewModel.addCityTapped()
    }
    
    func openAbout() {
        viewModel.aboutButtonTapped()
    }
    
    func refreshCitiesTapped(_ sender: UIButton) {
        viewModel.fetchWeather()
    }
    
}

extension String {
    func convertHourFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: date)
    }
    
    func convertDayFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: date)
    }
    
}
