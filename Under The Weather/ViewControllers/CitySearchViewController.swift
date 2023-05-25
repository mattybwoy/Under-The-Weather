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
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("clicked!")
    }
}
