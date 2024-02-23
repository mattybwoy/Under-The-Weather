//
//  HourlyCollectionView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 05/07/2023.
//

import SwiftUI

struct HourlyCollectionView: View {

    let hours: [HourlyWeather]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(hours, id: \.self) { hour in
                    VStack {
                        Text(hour.date.convertHourFormat())
                            .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 14)!))
                        Image(String(hour.icon))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                        Text(String(hour.temperature) + "°c")
                            .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 14)!))
                    }
                }
            }
        }
        .padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("background2"), lineWidth: 2)
        )
        .shadow(color: .gray, radius: 5)
        .scrollIndicators(.hidden)
    }
}

let weatherArray: [HourlyWeather] = [.init(date: "Today", icon: 2, summary: "Storm", temperature: 30), .init(date: "Today", icon: 2, summary: "Storm", temperature: 30), .init(date: "Today", icon: 2, summary: "Storm", temperature: 30), .init(date: "Today", icon: 2, summary: "Storm", temperature: 30), .init(date: "Today", icon: 2, summary: "Storm", temperature: 30), .init(date: "Today", icon: 2, summary: "Storm", temperature: 30)]
