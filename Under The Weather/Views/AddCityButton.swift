//
//  AddCityButton.swift
//  Under The Weather
//
//  Created by Matthew Lock on 17/06/2023.
//

import SwiftUI

struct AddCityButton: View {
    var body: some View {
        VStack {
            Button {
                print("City Added!")
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            }
            Text("Add City")
                .font(Font(uiFont: UIFont(name: "ComicNeueSansID", size: 13)!))
                .background(.red)
        }
        .padding(5)
    }
}

struct AddCityButton_Previews: PreviewProvider {
    static var previews: some View {
        AddCityButton()
    }
}
