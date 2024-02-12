//
//  CityWeatherView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 15/07/2023.
//

import SwiftUI

struct CityWeatherView: View {
    
    @EnvironmentObject var cities: DataStorageService
    @EnvironmentObject var parent: WeatherViewController
    @EnvironmentObject var viewModel: WeatherViewModel
    
    @State var viewedCity: String = ""
    
    var body: some View {
        CityCollectionView(viewedCity: $viewedCity)
        if viewModel.isLoading {
            LoadingView(viewedCity: $viewedCity)
        } else {
            WeatherTableView(viewedCity: $viewedCity)
        }
    }
}
