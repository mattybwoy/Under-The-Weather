//
//  WeatherTableViewCell.swift
//  Under The Weather
//
//  Created by Matthew Lock on 01/07/2023.
//

import SwiftUI

struct WeatherTableViewCell: View {
    
    @EnvironmentObject var cities: DataStorageService
    
    var body: some View {
        ForEach(cities.userCityObject, id: \.id) { city in
            HStack {
                Spacer()
                    VStack(alignment: .trailing) {
                        ForEach(cities.userWeatherData, id: \.self) { weather in
                            Image(String(weather.current.icon_num))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                            Spacer()
                            HStack {
                                Text(city.name)
                                    .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 38)!))
                                Spacer()
                                VStack {
                                    Text(String(weather.current.temperature) + "°c")
                                        .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 38)!))
                                    Text(weather.current.summary)
                                        .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 18)!))
                                }

                            }
                            
                        }
                    }
            }
        }
    }
}

let weatherDataSource = DataStorageService.sharedUserData

struct WeatherTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        WeatherTableViewCell().environmentObject(weatherDataSource)
    }
}
