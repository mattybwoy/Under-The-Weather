//
//  UserCity.swift
//  Under The Weather
//
//  Created by Matthew Lock on 18/06/2023.
//

struct UserCity: Codable, Hashable {
    let name: String
    let place_id: String
    let country: String
    let image: String
}
