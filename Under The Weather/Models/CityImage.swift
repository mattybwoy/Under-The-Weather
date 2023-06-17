//
//  CityImage.swift
//  Under The Weather
//
//  Created by Matthew Lock on 16/06/2023.
//

import Foundation

struct CityImages: Codable {
    let hits: [PlaceImage]
}

struct PlaceImage: Codable {
    let previewURL: String
}
