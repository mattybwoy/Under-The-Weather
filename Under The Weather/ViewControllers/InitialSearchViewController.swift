//
//  InitialSearchViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 15/05/2023.
//

import UIKit

class InitialSearchViewController: GenericViewController<InitialSearchView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        contentView.searchBar.delegate = self
        navigationItem.titleView = contentView.searchBar
    }
    
    override func loadView() {
        self.view = InitialSearchView()
    }

    var contentView: InitialSearchView {
        view as! InitialSearchView
    }

}

extension InitialSearchViewController: UISearchBarDelegate {
    
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
    
}
