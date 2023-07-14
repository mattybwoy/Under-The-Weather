//
//  AddCityButton.swift
//  Under The Weather
//
//  Created by Matthew Lock on 17/06/2023.
//

import SwiftUI

struct AddCityButton: View {
    @State var isPresented = false
    //@ObservedObject var viewModel: ViewModel
    @EnvironmentObject var parent: WeatherViewController
    
    var body: some View {
        VStack {
            Button {
                isPresented.toggle()
                //parent.addCitytapped()
            }
        label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
        }
        .sheet(isPresented: $isPresented) {
            AddCitySearchView()
                .ignoresSafeArea()
        }
        .animation(.easeIn(duration: 0.25), value: isPresented)
            Text("Add City")
                .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 13)!))
                .background(.red)
        }
        .padding(5)
    }
    
}

