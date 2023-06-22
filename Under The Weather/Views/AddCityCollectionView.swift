//
//  AddCityCollectionView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 03/06/2023.
//

import SwiftUI

struct AddCityCollectionView: View {
    
    let rows = [GridItem(.flexible())]
    
    var cities: [UserCity]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, alignment: .lastTextBaseline, spacing: 20 ) {
                AddCityButton()
                ForEach(cities, id: \.self) { city in
                    VStack {
                        Button {
                            print("City tapped!")
                        } label: {
                            AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2014/11/13/23/34/palace-530055_150.jpg")) { phase in
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
        let london = UserCity(name: "London", place_id: "london", country: "United Kingdom", image: "https://cdn.pixabay.com/photo/2014/11/13/23/34/palace-530055_150.jpg")
        
        AddCityCollectionView(cities: [london])
        //AddCityCollectionView(cities: DataStorageService.sharedUserData.userCityObject)
    }
}
