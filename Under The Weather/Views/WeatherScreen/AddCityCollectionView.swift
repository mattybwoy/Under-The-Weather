//
//  AddCityCollectionView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 03/06/2023.
//

import SwiftUI

struct AddCityCollectionView: View {
    
    let rows = [GridItem(.flexible())]
    
    @EnvironmentObject var cities: DataStorageService
    @State private var showingAlert = false
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, alignment: .lastTextBaseline, spacing: 20 ) {
                AddCityButton()
                ForEach(cities.userCityObject, id: \.id) { city in
                    VStack {
                        Button {
                            print("City tapped!")
                        } label: {
                            AsyncImage(url: URL(string: city.image)) { phase in
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
                                        print(DataStorageService.sharedUserData.userWeatherData)
                                    }
                            )
                            .alert(isPresented: $showingAlert) {
                                Alert(title: Text("Alert"), message: Text("Are you sure you want to delete this city?"),
                                      primaryButton: .destructive(Text("Yes")) {
                                    print("Deleted")
                                },
                                      secondaryButton: .cancel())
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


let userData = DataStorageService.sharedUserData

struct AddCityCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        AddCityCollectionView().environmentObject(userData)
    }
}
