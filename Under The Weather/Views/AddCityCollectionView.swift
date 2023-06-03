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
            LazyHGrid(rows: rows, alignment: .firstTextBaseline, spacing: 20 ) {
                ForEach(cities, id: \.self) { city in
                    VStack {
                        Image(systemName: "circle.fill")
                             .resizable()
                             .scaledToFit()
                             .frame(width: 30, height: 30)
                        Text(city)
                            .background(.red)
                    }
                }
            }
        }
        .frame(width: 350, height: 60)
    }
}

struct AddCityCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        AddCityCollectionView()
    }
}
