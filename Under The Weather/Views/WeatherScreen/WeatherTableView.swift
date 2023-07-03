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
            ForEach(Array(zip(cities.userWeatherData, cities.userCityObject)), id: \.0) { weather, city in
                WeatherTableViewCell(cityName: city.name,
                                     weatherIcon: weather.current.icon_num,
                                     currentTemperature: weather.current.temperature,
                                     weatherSummary: weather.current.summary,
                                     windSpeed: weather.current.wind.speed,
                                     windAngle: weather.current.wind.angle,
                                     windDirection: weather.current.wind.dir)
            }
        }
        .frame(maxWidth: .infinity)
        .listStyle(PlainListStyle())
    }
}

let weatherData = DataStorageService.sharedUserData

struct WeatherTableView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherTableView().environmentObject(weatherData)
    }
}
