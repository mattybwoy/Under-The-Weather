//
//  AddCityButton.swift
//  Under The Weather
//
//  Created by Matthew Lock on 17/06/2023.
//

import SwiftUI

struct AddCityButton: View {
    
    @EnvironmentObject var cities: DataStorageService
    @State var isPresented = false
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Button {
                if cities.userCityObject.count == 5 {
                    showAlert.toggle()
                }
                isPresented.toggle()
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Alert"), message: Text("Maximum number of cities reached"),
                  dismissButton: .default(Text("OK")))
        }
    }
    
}

