//
//  WeatherTableViewCell.swift
//  Under The Weather
//
//  Created by Matthew Lock on 01/07/2023.
//

import SwiftUI

struct WeatherTableViewCell: View {

    let cityName: String
    let weatherIcon: Int
    let currentTemperature: Double
    let weatherSummary: String
    let windSpeed: Double
    let windAngle: Double
    let windDirection: String

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                Image(String(weatherIcon))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                Spacer()
                HStack {
                    Text(cityName)
                        .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 38)!))
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    VStack {
                        Text(String(currentTemperature) + "°c")
                            .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 38)!))
                        Text(weatherSummary)
                            .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 18)!))
                    }
                }
                HStack {
                    VStack {
                        Image("wind")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                        Text(String(windSpeed) + "mph")
                            .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 18)!))
                    }
                    Spacer()
                    VStack {
                        Image("angle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                        Text(String(windAngle) + "°")
                            .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 18)!))
                    }
                    Spacer()
                    VStack {
                        Image("compass")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                        Text(windDirection)
                            .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 18)!))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
