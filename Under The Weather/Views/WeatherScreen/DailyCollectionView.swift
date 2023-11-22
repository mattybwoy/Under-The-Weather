//
//  DailyCollectionView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 06/07/2023.
//

import SwiftUI

struct DailyCollectionView: View {

    let dailyWeather: [DailyWeather]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(dailyWeather, id: \.self) { daily in
                    VStack {
                        Text(daily.day.convertDayFormat())
                            .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 14)!))
                        Image(String(daily.icon))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                        Text(String(daily.all_day.temperature) + "°c")
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

struct DailyCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        DailyCollectionView(dailyWeather: [])
    }
}
