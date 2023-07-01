//
//  Weather.swift
//  Under The Weather
//
//  Created by Matthew Lock on 15/06/2023.
//

struct Weather: Codable, Hashable {
    let current: CurrentWeather
}

struct CurrentWeather: Codable, Hashable {
    let icon: String
    let icon_num: Int
    let summary: String
    let temperature: Double
    let wind: Wind
}

struct Wind: Codable, Hashable {
    let speed: Double
    let angle: Double
    let dir: String
}
