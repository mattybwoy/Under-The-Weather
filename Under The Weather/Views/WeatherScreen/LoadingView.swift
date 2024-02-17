//
//  LoadingView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 12/02/2024.
//

import SwiftUI

struct LoadingView: View {

    @Binding var viewedCity: String

    var body: some View {
        GeometryReader { proxy in
            TabView(selection: $viewedCity) {
                ForEach(Array(zip(dummyWeather, dummyCity)), id: \.0) { weather, city in
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
        .redacted(reason: .placeholder)
        .allowsHitTesting(false)
    }

}

let dummyCity: [UserCity] = [.init(name: "New York", place_id: "new_york", country: "America", image: "america.png")]
let dummyWeather: [Weather] = [.init(current: .init(icon: "12", icon_num: 2, summary: "Thunderstorms", temperature: 30.0, wind: .init(speed: 20.0, angle: 20.0, dir: "NW")),
                                     hourly: .init(data: [.init(date: "12/02/24", icon: 2, summary: "Thunderstorms", temperature: 30.0), .init(date: "13/02/24", icon: 1, summary: "Storm", temperature: 30.0), .init(date: "14/02/24", icon: 1, summary: "Storm", temperature: 30.0), .init(date: "15/02/24", icon: 1, summary: "Storm", temperature: 30.0), .init(date: "16/02/24", icon: 1, summary: "Storm", temperature: 30.0), .init(date: "17/02/24", icon: 1, summary: "Storm", temperature: 30.0)]),
                                     daily: .init(data: [.init(day: "Today", icon: 2, all_day: .init(temperature: 30.0)), .init(day: "Tomorrow", icon: 2, all_day: .init(temperature: 30.0)), .init(day: "14/02/24", icon: 2, all_day: .init(temperature: 30.0)), .init(day: "15/02/24", icon: 2, all_day: .init(temperature: 30.0)), .init(day: "16/02/24", icon: 2, all_day: .init(temperature: 30.0)), .init(day: "17/02/24", icon: 2, all_day: .init(temperature: 30.0))]))]
