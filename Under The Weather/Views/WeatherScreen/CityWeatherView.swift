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
    @State var viewedCity: String = ""

    var body: some View {
        CityCollectionView(viewedCity: $viewedCity)
        if viewModel.isLoading == true {
            LoadingView(viewedCity: $viewedCity)
        } else {
            WeatherTableView(viewModel: _viewModel, viewedCity: $viewedCity)
        }
    }
}
