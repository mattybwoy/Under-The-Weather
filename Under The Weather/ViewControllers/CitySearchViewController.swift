//
//  CitySearchViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 15/05/2023.
//

import UIKit

final class CitySearchViewController: GenericViewController <CitySearchView>, CityVMDelegate {
    
    private let viewModel: CitySearchViewModel
    private var debounceTimer: Timer?
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
        viewModel.bind(to: rootView)
        viewModel.vmDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rootView.resultsTable.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        if isBeingDismissed {
            viewModel.didDismiss(viewController: self)
        }
        super.viewWillDisappear(animated)
    }

    func presentAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.rootView.resultsTable.reloadData()
        }
    }
    
}

extension CitySearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchTextDebounce(searchText: searchText)
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
            self.viewModel.selected = nil
            self.viewModel.selectedCity = nil
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
        if indexPath.row == viewModel.selected {
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
        viewModel.selected = indexPath.row
        viewModel.selectedCity = cityResults[indexPath.row]
        self.rootView.resultsTable.reloadData()
    }
    
}
