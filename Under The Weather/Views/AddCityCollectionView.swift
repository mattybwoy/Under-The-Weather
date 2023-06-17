//
//  AddCityCollectionView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 03/06/2023.
//

import SwiftUI

struct AddCityCollectionView: View {
    
    let rows = [GridItem(.flexible())]
    
    //let cities = ["London", "Paris", "New York", "Tokyo", "Hong Kong"]
    var cities: [Cities]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, alignment: .lastTextBaseline, spacing: 20 ) {
                AddCityButton()
                ForEach(cities, id: \.self) { city in
                    VStack {
                        Button {
                            print("City tapped!")
                        } label: {
                            Image(systemName: "circle.fill")
                                 .resizable()
                                 .scaledToFit()
                                 .frame(width: 60, height: 60)
                        }
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
}

public extension Font {
  init(uiFont: UIFont) {
    self = Font(uiFont as CTFont)
  }
}

struct AddCityCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        AddCityCollectionView(cities: DataStorageService.sharedUserData.cityObjects)
    }
}
