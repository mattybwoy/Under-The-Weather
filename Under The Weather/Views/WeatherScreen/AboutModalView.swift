//
//  AboutView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 10/07/2023.
//

import SwiftUI

struct AboutModalView: View {

    var body: some View {
        VStack {
            Image(uiImage: UIImage(named: "UnderTheWeatherTransparent")!)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            Text("All weather results provided courtesy of Meteosource")
                .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 18)!))
                .foregroundColor(Color("TitleTextColor"))
                .multilineTextAlignment(.center)
            Text("All images provided courtesy of Pixabay")
                .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 18)!))
                .foregroundColor(Color("TitleTextColor"))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RadialGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), center: .center, startRadius: 50, endRadius: 500).opacity(1)
        )
    }

}
