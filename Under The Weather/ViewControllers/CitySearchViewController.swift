//
//  CitySearchViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 15/05/2023.
//

import UIKit

class CitySearchViewController: GenericViewController <CitySearchView> {
    
    private let viewModel: CitySearchViewModel
    private var debounceTimer: Timer?
    private var selected: Int?
    private var selectedCity: Cities?
    
    init(viewModel: CitySearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        contentView.searchBar.delegate = self
        contentView.resultsTable.delegate = self
        contentView.resultsTable.dataSource = self
        setupNextButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        contentView.resultsTable.reloadData()
    }
    
    override func loadView() {
        self.view = CitySearchView()
    }
    
    var contentView: CitySearchView {
        view as! CitySearchView
    }
    
    func setupNextButton() {
        contentView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func nextButtonTapped() {
        guard selected != nil else {
            let alert = viewModel.throwAlert(title: "Alert", message: "Please select a city")
            return self.present(alert, animated: true)
        }
        
        guard let city = selectedCity else {
            return
        }
        
        DataStorageService.sharedUserData.loadUserCities()
        DataStorageService.sharedUserData.decodeToUserCityObject()
        //DataStorageService.sharedUserData.deleteCity(city: city)
        
        if DataStorageService.sharedUserData.checkCityExists(city: city) {

            let alert = viewModel.throwAlert(title: "Alert", message: "City already exists in your favourites please select a different city")
            return self.present(alert, animated: true)
        }

        if DataStorageService.sharedUserData.userCityObject.count > 5 {
            let alert = viewModel.throwAlert(title: "Alert", message: "Maximum number of cities exceeded, please delete a city before trying to add another")
            return self.present(alert, animated: true)
        } else {
            DataStorageService.sharedUserData.userCity = city
            NetworkService.sharedInstance.fetchCityImages(city: city.name) { result in
                switch result {
                case .success(let image):
                    let userCities = DataStorageService.sharedUserData.addUserCityObject(city: city, cityImage: image)
                    self.searchCityWeather(userCity: userCities)
                    DataStorageService.sharedUserData.addUserCity(cityObject: userCities)
                case .failure:
                    print("Unable to add City to Favourites, please try again")
                }
            }
        }
        selected = nil
        
        if !UserDefaults.hasSeenAppIntroduction {
            UserDefaults.hasSeenAppIntroduction = true
            viewModel.nextButtonTapped()
        } else {
            viewModel.closeModal()
        }
        
    }
    
    func searchCityWeather(userCity: [UserCity]) {
        NetworkService.sharedInstance.cityWeatherSearch(cities: userCity) { result in
            switch result {
            case .success(let weather):
                (print("Successful call to weather station"))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    deinit {
        print("CitySearchViewController deinitialized")
    }
    
}

extension CitySearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.debounceTimer?.invalidate()
        
        guard let text = contentView.searchBar.text, !text.isEmpty else {
            DataStorageService.sharedUserData.userSearchResults = nil
            selected = nil
            DispatchQueue.main.async {
                self.contentView.resultsTable.reloadData()
            }
            return
        }
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [weak self] _ in
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                NetworkService.sharedInstance.citySearch(city: text) { result in
                    switch result {
                    case .success(let cities):
                        self?.contentView.resultsTable.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        DispatchQueue.main.async {
            NetworkService.sharedInstance.citySearch(city: text) { result in
                switch result {
                case .success(let cities):
                    self.contentView.resultsTable.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            self.selected = nil
            self.selectedCity = nil
            self.contentView.resultsTable.reloadData()
        }
    }
    
    
}

extension CitySearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let total = DataStorageService.sharedUserData.userSearchResults?.count else {
            return 0
        }
        return total
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CitySearchTableViewCell.reuseIdentifier, for: indexPath) as? CitySearchTableViewCell else {
            fatalError("Results unable to load")
        }
        guard let cityResults = DataStorageService.sharedUserData.userSearchResults else {
            return cell
        }
        
        if cityResults[indexPath.row].country  == "United States of America" && cityResults[indexPath.row].adm_area1 != nil {
            guard let state = cityResults[indexPath.row].adm_area1 else {
                return cell
            }
            cell.countryName.text = "\(state), \(cityResults[indexPath.row].country)"
            cell.countryName.adjustsFontSizeToFitWidth = true
            cell.countryName.minimumScaleFactor = 0.2
        } else {
            cell.countryName.text = cityResults[indexPath.row].country
        }

        cell.cityName.text = cityResults[indexPath.row].name
        cell.layer.borderWidth = 1.0
        if indexPath.row == selected {
            cell.accessoryView = cell.filledCheckmarkIcon
        } else {
            cell.accessoryView = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cityResults = DataStorageService.sharedUserData.userSearchResults else {
            return
        }
        selected = indexPath.row
        selectedCity = cityResults[indexPath.row]
        self.contentView.resultsTable.reloadData()
    }
    
}
