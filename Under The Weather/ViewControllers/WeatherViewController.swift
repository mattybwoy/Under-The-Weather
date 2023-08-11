//
//  WeatherViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 29/04/2023.
//

import UIKit

class WeatherViewController: GenericViewController <WeatherView>, ObservableObject {
    
    private let viewModel: WeatherViewModel
    
    let leftButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))

    public init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        DataStorageService.sharedUserData.loadUserCities()
        let userCities = DataStorageService.sharedUserData.decodeToUserCityObject()
        NetworkService.sharedInstance.cityWeatherSearch(cities: userCities) { [weak self] result in
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
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "arrow.clockwise", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        leftButton.configuration = config
        leftButton.addTarget(self, action: #selector(refreshCities(_:)), for: .touchUpInside)
        leftButton.tintColor = UIColor(named: "background2")
        let leftBarButton = UIBarButtonItem(customView: leftButton)

        navigationItem.leftBarButtonItem = leftBarButton
        
        let rightButton = UIBarButtonItem(title: "About", style: .plain, target: self, action: #selector(openAbout))
        rightButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ComicNeueSansID", size: 20) as Any], for: .normal)
        rightButton.tintColor = UIColor(named: "background2")
        navigationItem.rightBarButtonItem = rightButton

        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func loadView() {
        self.view = WeatherView(weatherVC: self)
    }

    var contentView: WeatherView {
        view as! WeatherView
    }

    func addCitytapped() {
        viewModel.nextButtonTapped()
    }
    
    @objc func openAbout() {
        viewModel.aboutButtonTapped()
    }
    
    @objc func refreshCities(_ sender: UIButton) {
        let customView = sender
        let transform = CGAffineTransform(rotationAngle: .pi)
        let transform2 = CGAffineTransform(rotationAngle: .pi * 2)
        UIView.animate(withDuration: 1, animations: {
            customView.transform =  transform
            customView.transform = transform2
        }, completion: { (_) in
            customView.transform = .identity
        })
        
        NetworkService.sharedInstance.refreshWeather() { result in
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
