//
//  WeatherTableView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 03/06/2023.
//

import SwiftUI

struct WeatherTableView: View {
    
    @EnvironmentObject var cities: DataStorageService
    
    var body: some View {
        List {
            ForEach(cities.userWeatherData, id: \.self) { weather in
                WeatherTableViewCell().environmentObject(cities)
            }
        }
    }
}

let weatherData = DataStorageService.sharedUserData

struct WeatherTableView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherTableView().environmentObject(weatherData)
    }
}
