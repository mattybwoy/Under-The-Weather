//
//  CityCollectionView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 03/06/2023.
//

import SwiftUI

struct CityCollectionView: View {

    let rows = [GridItem(.flexible())]
    @EnvironmentObject var viewModel: WeatherViewModel
    @State private var firstAlert = false
    @State private var secondAlert = false

    var body: some View {
        ScrollViewReader { value in
            ScrollView(.horizontal) {
                LazyHGrid(rows: rows, alignment: .lastTextBaseline, spacing: 20) {
                    AddCityButton(viewModel: _viewModel)
                    ForEach(0..<viewModel.userCityObject.count, id: \.self) { index in
                        VStack {
                            Button {} label: {
                                AsyncImage(url: URL(string: viewModel.userCityObject[index].image)) { phase in
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
                                        guard viewModel.checkMoreThanOneCity else {
                                            return secondAlert = true
                                        }
                                        firstAlert = true
                                        viewModel.viewedCity = viewModel.userCityObject[index].place_id
                                    }
                            )
                            .highPriorityGesture(
                                TapGesture()
                                    .onEnded { _ in
                                        viewModel.viewedCity = viewModel.userCityObject[index].place_id
                                        viewModel.selected = index
                                        withAnimation {
                                            value.scrollTo(viewModel.selected, anchor: .center)
                                        }
                                    }
                            )
                            Text(viewModel.userCityObject[index].name)
                                .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 13)!))
                        }
                    }
                    .padding(.bottom, 5)
                }
                .padding(.horizontal)
            }
            .frame(width: 350, height: 100)
            .background(Color("background1"))
            .cornerRadius(20)
            .scrollIndicators(.hidden)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.yellow, lineWidth: 3)
            )
            .shadow(color: .gray, radius: 5)

            ZStack {}
                .alert(isPresented: $firstAlert) {
                    Alert(title: Text("Alert"),
                          message: Text("Are you sure you want to delete this city?"),
                          primaryButton: .destructive(Text("Yes")) {
                        viewModel.deleteCity(city: viewModel.viewedCity)
                          },
                          secondaryButton: .cancel())
                }
            ZStack {}
                .alert(isPresented: $secondAlert) {
                    Alert(title: Text("Alert"),
                          message: Text("Must have at least one city"),
                          dismissButton: .default(Text("OK")))
                }
        }
    }

}
