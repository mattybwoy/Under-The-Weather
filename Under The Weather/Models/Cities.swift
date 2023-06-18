//
//  Cities.swift
//  Under The Weather
//
//  Created by Matthew Lock on 13/05/2023.
//

struct Cities: Codable, Equatable, Hashable, Comparable {
    let name: String
    let place_id: String
    let adm_area1: String?
    let country: String
}
