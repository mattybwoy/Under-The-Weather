//
//  AddCityCollectionView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 03/06/2023.
//

import SwiftUI

struct AddCityCollectionView: View {
    
    let rows = [
        GridItem(.flexible())
        ]
    let cities = ["Add City","London", "Paris", "New York", "Tokyo", "Hong Kong"]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, alignment: .lastTextBaseline, spacing: 20 ) {
                ForEach(cities, id: \.self) { city in
                    VStack {
                        Image(systemName: "circle.fill")
                             .resizable()
                             .scaledToFit()
                             .frame(width: 60, height: 60)
                        Text(city)
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
    }
}

public extension Font {
  init(uiFont: UIFont) {
    self = Font(uiFont as CTFont)
  }
}

struct AddCityCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        AddCityCollectionView()
    }
}
