//
//  AddCitySearchView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 27/06/2023.
//

import SwiftUI

struct AddCitySearchView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> CitySearchViewController {
        let router = ScreenRouter(rootTransition: EmptyTransition())
        let viewModel = CitySearchViewModel(router: router)
        let vc = CitySearchViewController(viewModel: viewModel)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: CitySearchViewController, context: Context) {
        //
    }
}
