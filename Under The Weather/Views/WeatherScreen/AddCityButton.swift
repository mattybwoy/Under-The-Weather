//
//  AddCityButton.swift
//  Under The Weather
//
//  Created by Matthew Lock on 17/06/2023.
//

import SwiftUI

struct AddCityButton: View {

    @EnvironmentObject var viewModel: WeatherViewModel

    @State private var showAlert = false

    var body: some View {
        VStack {
            Button {
                if viewModel.userCityObject.count == 5 {
                    showAlert.toggle()
                } else {
                    viewModel.addCityTapped()
                }
            }
            label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color("background2"))
            }
            Text("Add City")
                .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 13)!))
        }
        .padding(5)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Alert"),
                  message: Text("Maximum number of cities reached"),
                  dismissButton: .default(Text("OK")))
        }
    }

}
