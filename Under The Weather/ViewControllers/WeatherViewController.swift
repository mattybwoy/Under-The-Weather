//
//  WeatherViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 29/04/2023.
//

import UIKit

class WeatherViewController: GenericViewController <WeatherView>, ObservableObject {
    
    private let viewModel: WeatherViewModel
    private let dataStorage: DataStorageService
    private let networkService: NetworkService

    public init(viewModel: WeatherViewModel, dataStorage: DataStorageService = .sharedUserData, networkService: NetworkService = .sharedInstance) {
        self.viewModel = viewModel
        self.dataStorage = dataStorage
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
        dataStorage.loadUserCities()
        let userCities = dataStorage.decodeToUserCityObject()
        networkService.cityWeatherSearch(cities: userCities) { [weak self] result in
            switch result {
            case .success(let weather):
                print("success")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftBarButton = UIBarButtonItem(customView: leftBarButton)
        navigationItem.leftBarButtonItem = leftBarButton
        let rightBarButton = UIBarButtonItem(customView: rightBarButton)
        navigationItem.rightBarButtonItem = rightBarButton
        
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func loadView() {
        self.view = WeatherView(weatherVC: self)
    }

    var contentView: WeatherView {
        view as! WeatherView
    }
    
    var leftBarButton: UIButton {
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        var leftConfig = UIButton.Configuration.plain()
        leftConfig.image = UIImage(systemName: "arrow.clockwise", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        leftButton.configuration = leftConfig
        leftButton.addTarget(self, action: #selector(refreshCities(_:)), for: .touchUpInside)
        leftButton.tintColor = UIColor(named: "background2")
        return leftButton
    }
    
    var rightBarButton: UIButton {
       let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        var rightConfig = UIButton.Configuration.plain()
        rightConfig.image = UIImage(systemName: "info.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        rightButton.configuration = rightConfig
        rightButton.addTarget(self, action: #selector(openAbout), for: .touchUpInside)
        rightButton.tintColor = UIColor(named: "background2")
        return rightButton
    }

    func addCitytapped() {
        viewModel.nextButtonTapped()
    }
    
    @objc func openAbout() {
        viewModel.aboutButtonTapped()
    }
    
    @objc func refreshCities(_ sender: UIButton) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, animations: {
                sender.transform =  CGAffineTransform(rotationAngle: .pi)
                sender.transform = CGAffineTransform(rotationAngle: .pi * 2)
            })
        }
        networkService.refreshWeather() { result in
            switch result {
            case .success:
                print("refreshed!")
                break
            case .failure:
                break
            }
        }
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
