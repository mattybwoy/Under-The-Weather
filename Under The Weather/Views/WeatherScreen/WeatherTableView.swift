//
//  WeatherTableView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 03/06/2023.
//

import SwiftUI

struct WeatherTableView: View {

    @EnvironmentObject var viewModel: WeatherViewModel

    var body: some View {
        GeometryReader { proxy in
            TabView(selection: $viewModel.viewedCity) {
                ForEach(Array(zip(viewModel.userWeatherData, viewModel.userCityObject)), id: \.0) { weather, city in
                    VStack {
                        WeatherTableViewCell(cityName: city.name,
                                             weatherIcon: weather.current.icon_num,
                                             currentTemperature: weather.current.temperature,
                                             weatherSummary: weather.current.summary,
                                             windSpeed: weather.current.wind.speed,
                                             windAngle: weather.current.wind.angle,
                                             windDirection: weather.current.wind.dir)
                        HourlyCollectionView(hours: weather.hourly.data)
                        DailyCollectionView(dailyWeather: weather.daily.data)
                    }
                    .tag(city.place_id)
                    .padding()
                    .rotationEffect(.degrees(-90))
                    .frame(width: proxy.size.width,
                           height: proxy.size.height)
                }
            }
            .frame(width: proxy.size.height,
                   height: proxy.size.width)
            .rotationEffect(.degrees(90), anchor: .topLeading)
            .offset(x: proxy.size.width)
            .tabViewStyle(
                PageTabViewStyle(indexDisplayMode: .never)
            )
            .ignoresSafeArea()
        }
        .frame(width: 400, height: 600)
    }

}

public extension Font {
    init(uiFont: UIFont) {
        self = Font(uiFont as CTFont)
    }
}
