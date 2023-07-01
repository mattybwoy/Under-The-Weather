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
                        HStack {
                            VStack {
                                Image("wind")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                Text(String(weather.current.wind.speed) + "mph")
                                    .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 18)!))
                            }
                            Spacer()
                            VStack {
                                Image("angle")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                Text(String(weather.current.wind.speed) + "°")
                                    .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 18)!))
                            }
                            Spacer()
                            VStack {
                                Image("compass")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                Text(weather.current.wind.dir)
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
