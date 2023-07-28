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
    @State var viewedCity: String?
    @State var selectedCity: Int?
    @State private var showingAlert = false
    
    var body: some View {
        ScrollViewReader { value in
                VStack {
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: rows, alignment: .lastTextBaseline, spacing: 20) {
                            AddCityButton()
                            ForEach(0..<cities.userCityObject.count) { i in
                                VStack {
                                    Button {
                                        print("City tapped!")
                                    } label: {
                                        AsyncImage(url: URL(string: cities.userCityObject[i].image)) { phase in
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
                                                showingAlert = true
                                                print("Loooong")
                                            }
                                    )
                                    .highPriorityGesture(
                                        TapGesture()
                                            .onEnded { _ in
                                                print("Tap")
                                                viewedCity = cities.userCityObject[i].place_id
                                                selectedCity = i
                                            }
                                    )
                                    .alert(isPresented: $showingAlert) {
                                        Alert(title: Text("Alert"), message: Text("Are you sure you want to delete this city?"),
                                              primaryButton: .destructive(Text("Yes")) {
                                            print("Deleted")
                                        },
                                              secondaryButton: .cancel())
                                    }
                                    Text(cities.userCityObject[i].name)
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
                                    .tag(city)
                            }
                            .padding()
                            .rotationEffect(.degrees(-90))
                            .frame(
                                width: proxy.size.width,
                                height: proxy.size.height
                            )
                        }
                        .onChange(of: viewedCity, perform: { newValue in
                            withAnimation {
                                print(Array(zip(cities.userWeatherData, cities.userCityObject))[selectedCity!].1)
                                value.scrollTo(Array(zip(cities.userWeatherData, cities.userCityObject))[selectedCity!].1, anchor: .top)
                            }
                        })
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
            }
    }
  
}

public extension Font {
  init(uiFont: UIFont) {
    self = Font(uiFont as CTFont)
  }
}
