//
//  WeatherTableView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 03/06/2023.
//

import SwiftUI

struct WeatherTableView: View {
    
    let rows = [GridItem(.flexible())]
    @EnvironmentObject var cities: DataStorageService
    @State var viewedCity: String = ""
    @State private var showingAlert = false
    @State private var secondAlert = false
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHGrid(rows: rows, alignment: .lastTextBaseline, spacing: 20) {
                    AddCityButton()
                    ForEach(cities.userCityObject, id: \.self) { city in
                        VStack {
                            Button {
                                print("City tapped!")
                            } label: {
                                AsyncImage(url: URL(string: city.image)) { phase in
                                    if let image = phase.image {
                                        image.resizable()
                                        image.scaledToFit()
                                    } else if phase.error != nil {
                                        Image(systemName: "questionmark.circle")
                                            .resizable()
                                            .scaledToFit()
                                    } else {
                                        ProgressView()
                                    }
                                }
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: 2))
                            }
                            .simultaneousGesture(
                                LongPressGesture()
                                    .onEnded { _ in
                                        guard cities.checkMoreThanOneCity() else {
                                            return secondAlert = true
                                        }
                                        showingAlert = true
                                        viewedCity = city.place_id
                                    }
                            )
                            .highPriorityGesture(
                                TapGesture()
                                    .onEnded { _ in
                                        viewedCity = city.place_id
                                    }
                            )
                            Text(city.name)
                                .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 13)!))
                                .background(.red)
                        }
                    }
                    .padding(.bottom, 5)
                }
                .padding(.horizontal)
            }
            .frame(width: 350, height: 100)
            .scrollIndicators(.hidden)
            .background(.green)
            .border(.yellow, width: 3)
            .cornerRadius(20)
        }
        GeometryReader { proxy in
            TabView(selection: $viewedCity) {
                ForEach(Array(zip(cities.userWeatherData, cities.userCityObject)), id: \.0) { weather, city in
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
                    .frame(
                        width: proxy.size.width,
                        height: proxy.size.height
                    )
                }
            }
            .frame(
                width: proxy.size.height,
                height: proxy.size.width
            )
            .rotationEffect(.degrees(90), anchor: .topLeading)
            .offset(x: proxy.size.width)
            .tabViewStyle(
                PageTabViewStyle(indexDisplayMode: .never)
            )
            .ignoresSafeArea()
        }
        .frame(width: 400, height: 600)
        
        ZStack {}
            .alert(isPresented: $showingAlert) {
                
                Alert(title: Text("Alert"), message: Text("Are you sure you want to delete this city?"),
                      primaryButton: .destructive(Text("Yes")) {
                    
                    cities.deleteCity(city: viewedCity)
                },
                      secondaryButton: .cancel())
            }
        
        ZStack {}
            .alert(isPresented: $secondAlert) {
                Alert(title: Text("Alert"), message: Text("Must have at least one city"),
                      dismissButton: .default(Text("OK")))
            }
    }
    
}

public extension Font {
  init(uiFont: UIFont) {
    self = Font(uiFont as CTFont)
  }
}
