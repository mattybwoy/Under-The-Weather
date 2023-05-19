//
//  InitialSearchViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 15/05/2023.
//

import UIKit

class InitialSearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.searchController = SearchController
        SearchController.searchResultsUpdater = self
        SearchController.obscuresBackgroundDuringPresentation = false
        SearchController.searchBar.delegate = self
        setupSearchController()
    }
    
    func setupSearchController() {
        title = "City Search"
        
    }
    
    private var SearchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Searching..."
        return searchController
    }()
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        SearchController.searchBar.text = ""
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            return
        }
        DispatchQueue.main.async {
            DataManager.sharedInstance.prefixCitySearch(city: text) { result in
                switch result {
                case .success(let cities):
                    print("hello" + String(cities.count))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }

    }
}
