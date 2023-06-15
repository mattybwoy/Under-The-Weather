//
//  Weather.swift
//  Under The Weather
//
//  Created by Matthew Lock on 15/06/2023.
//

struct Weather: Codable {
    let current: CurrentWeather
}

struct CurrentWeather: Codable {
    let icon: String
    let summary: String
    let temperature: Int
    let wind: Wind
}

struct Wind: Codable {
    let speed: Int
    let angle: Int
    let dir: String
}
