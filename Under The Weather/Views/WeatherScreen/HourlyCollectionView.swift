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
                        Text(hour.date.convertDateFormat())
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
            .scrollIndicators(.hidden)
        }
    }
}

struct HourlyCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyCollectionView(hours: [])
    }
}
