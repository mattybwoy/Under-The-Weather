//
//  CityWeatherView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 15/07/2023.
//

import SwiftUI

struct CityWeatherView: View {
    
    @EnvironmentObject var viewModel: WeatherViewModel
    @EnvironmentObject var parent: WeatherViewController

    var body: some View {
        CityCollectionView(viewModel: _viewModel)
        if viewModel.isLoading == true {
            LoadingView(viewModel: _viewModel)
        } else {
            WeatherTableView(viewModel: _viewModel)
        }
    }
}
