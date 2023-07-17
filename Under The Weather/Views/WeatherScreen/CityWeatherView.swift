//
//  CityWeatherView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 15/07/2023.
//

import SwiftUI

struct CityWeatherView: View {
    
    @EnvironmentObject var cities: DataStorageService
    //@State var selectedCity: UserCity? = nil
    
    var body: some View {

            //CityCollectionView(selectedCity: $selectedCity)
            WeatherTableView()
        
    }
}
