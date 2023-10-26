//
//  CitySearchViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 15/05/2023.
//

import UIKit

final class CitySearchViewController: GenericViewController <CitySearchView>, CityDelegate {
    
    private let viewModel: CitySearchViewModel
    private var debounceTimer: Timer?
    private var selected: Int?
    private var selectedCity: Cities?
    private let dataStorage: DataStorageService
    private let networkService: NetworkService
    
    init(viewModel: CitySearchViewModel, dataStorage: DataStorageService = .sharedUserData, networkService: NetworkService = .sharedInstance) {
        self.viewModel = viewModel
        self.dataStorage = dataStorage
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor(named: "background2")
        rootView.searchBar.delegate = self
        rootView.resultsTable.delegate = self
        rootView.resultsTable.dataSource = self
        rootView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rootView.resultsTable.reloadData()
    }

    // every bit of the logic within this method should be in the view model.
    // the vc should only be responsible for managing views. Consider making
    // the view model the delegate instead
    func nextButtonTapped() {
        guard selected != nil else {
            let alert = viewModel.throwAlert(message: "Please select a city")
            return self.present(alert, animated: true)
        }
        
        guard let city = selectedCity else {
            return
        }
        
        dataStorage.loadUserCities()
        dataStorage.decodeToUserCityObject()
        
        if dataStorage.checkCityExists(city: city) {
            let alert = viewModel.throwAlert(message: "City already exists in your favourites please select a different city")
            return self.present(alert, animated: true)
        }

        if dataStorage.userCityObject.count > 5 {
            let alert = viewModel.throwAlert(message: "Maximum number of cities exceeded, please delete a city before trying to add another")
            return self.present(alert, animated: true)
        } else {
            dataStorage.userCity = city
            let searchTermImage = city.name.replacingOccurrences(of: " ", with: "+")
            networkService.fetchCityImages(city: searchTermImage) { [weak self] result in
                switch result {
                case .success(let image):
                    let userCities = self?.dataStorage.addUserCityObject(city: city, cityImage: image)
                    self?.searchCityWeather(userCity: userCities ?? [])
                    self?.dataStorage.addUserCity(cityObject: userCities ?? [])
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        selected = nil
        dataStorage.userSearchResults? = []
        
        if !UserDefaults.hasSeenAppIntroduction {
            UserDefaults.hasSeenAppIntroduction = true
            viewModel.nextButtonTapped()
        } else {
            viewModel.nextButtonTapped()
        }
        
    }

    // should also be in the view model
    func searchCityWeather(userCity: [UserCity]) {
        networkService.cityWeatherSearch(cities: userCity) { [weak self] _ in
        }
    }
    
}

extension CitySearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        // all of this logic should be in the view model
        self.debounceTimer?.invalidate()
        
        guard let text = rootView.searchBar.text, !text.isEmpty else {
            dataStorage.userSearchResults = nil
            selected = nil
            DispatchQueue.main.async {
                self.rootView.resultsTable.reloadData()
            }
            return
        }
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [weak self] _ in
            let searchTerm = text.replacingOccurrences(of: " ", with: "%20")
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                self?.networkService.citySearch(city: searchTerm) { result in
                    switch result {
                    case .success:
                        self?.rootView.resultsTable.reloadData()
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
        
        let searchTerm = text.replacingOccurrences(of: " ", with: "%20")
        
        DispatchQueue.main.async {
            self.networkService.citySearch(city: searchTerm) { [weak self] result in
                switch result {
                case .success:
                    self?.rootView.resultsTable.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            self.selected = nil
            self.selectedCity = nil
        }
    }
    
    
}

extension CitySearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let total = dataStorage.userSearchResults?.count else {
            return 0
        }
        return total
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CitySearchTableViewCell.reuseIdentifier, for: indexPath) as? CitySearchTableViewCell else {
            fatalError("Results unable to load")
        }
        guard let cityResults = dataStorage.userSearchResults else {
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
        guard let cityResults = dataStorage.userSearchResults else {
            return
        }
        selected = indexPath.row
        selectedCity = cityResults[indexPath.row]
        self.rootView.resultsTable.reloadData()
    }
    
}
