//
//  CityCollectionView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 03/06/2023.
//

import SwiftUI

struct CityCollectionView: View {
    
    let rows = [GridItem(.flexible())]
    @EnvironmentObject var cities: DataStorageService
    @Binding var viewedCity: String
    @State private var firstAlert = false
    @State private var secondAlert = false
    @State private var selected: Int = 0
    
    var body: some View {
        ScrollViewReader { value in
            ScrollView(.horizontal) {
                LazyHGrid(rows: rows, alignment: .lastTextBaseline, spacing: 20) {
                    AddCityButton()
                    ForEach(0..<cities.userCityObject.count, id: \.self) { index in
                        VStack {
                            Button {
                                print("City tapped!")
                            } label: {
                                AsyncImage(url: URL(string: cities.userCityObject[index].image)) { phase in
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
                                        guard cities.checkMoreThanOneCity() else {
                                            return secondAlert = true
                                        }
                                        firstAlert = true
                                        viewedCity = cities.userCityObject[index].place_id
                                    }
                            )
                            .highPriorityGesture(
                                TapGesture()
                                    .onEnded { _ in
                                        viewedCity = cities.userCityObject[index].place_id
                                        selected = index
                                        withAnimation {
                                            value.scrollTo(selected, anchor: .center)
                                        }
                                    }
                            )
                            Text(cities.userCityObject[index].name)
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
            
            ZStack {}
                .alert(isPresented: $firstAlert) {
                    Alert(title: Text("Alert"), message: Text("Are you sure you want to delete this city?"),
                          primaryButton: .destructive(Text("Yes")) {
                        cities.deleteCity(city: viewedCity)
                    },
                          secondaryButton: .cancel())
                }
            ZStack {}
                .alert(isPresented: $secondAlert) {
                    Alert(title: Text("Alert"), message: Text("Must have at least one city"),
                          dismissButton: .default(Text("OK")))
                }
        }
    }
    
}
