//
//  CitySearchViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 15/05/2023.
//

import UIKit

final class CitySearchViewController: GenericViewController <CitySearchView>, CityVMDelegate {
    
    private let viewModel: CitySearchViewModel
    
    init(viewModel: CitySearchViewModel) {
        self.viewModel = viewModel
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
        viewModel.searchButtonClick(searchTerm: text)
    }

}

extension CitySearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let total = viewModel.dataStorage.userSearchResults?.count else {
            return 0
        }
        return total
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CitySearchTableViewCell.reuseIdentifier, for: indexPath) as? CitySearchTableViewCell else {
            fatalError("Results unable to load")
        }
        guard let cityResults = viewModel.dataStorage.userSearchResults else {
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
        guard let cityResults = viewModel.dataStorage.userSearchResults else {
            return
        }
        viewModel.selected = indexPath.row
        viewModel.selectedCity = cityResults[indexPath.row]
        self.rootView.resultsTable.reloadData()
    }
    
}
