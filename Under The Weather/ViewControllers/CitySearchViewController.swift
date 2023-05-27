//
//  CitySearchViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 15/05/2023.
//

import UIKit

class CitySearchViewController: GenericViewController<CitySearchView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        contentView.searchBar.delegate = self
        navigationItem.titleView = contentView.searchBar
        contentView.resultsTable.delegate = self
        contentView.resultsTable.dataSource = self
    }
    
    override func loadView() {
        self.view = CitySearchView()
    }

    var contentView: CitySearchView {
        view as! CitySearchView
    }

}

extension CitySearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = contentView.searchBar.text, !text.isEmpty else {
            return
        }
        DispatchQueue.main.async {
            DataManager.sharedInstance.prefixCitySearch(city: text) { result in
                switch result {
                case .success(let cities):
                    print("hello" + String(cities.count))
                    self.contentView.resultsTable.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.contentView.resultsTable.reloadData()
        }
    }
}

extension CitySearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let total = DataManager.sharedInstance.citiesSearchResults?.count else {
            return 0
        }
        return total
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CitySearchTableViewCell.reuseIdentifier, for: indexPath) as! CitySearchTableViewCell
        guard let cityResults = DataManager.sharedInstance.citiesSearchResults else {
            return cell
        }
        cell.countryName.text = cityResults[indexPath.row].country
        cell.cityName.text = cityResults[indexPath.row].name
        cell.layer.borderWidth = 1.0
        return cell
    }
    
}
