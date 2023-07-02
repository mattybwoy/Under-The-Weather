//
//  Weather.swift
//  Under The Weather
//
//  Created by Matthew Lock on 15/06/2023.
//

struct Weather: Codable, Hashable {
    let current: CurrentWeather
    let hourly: Hourly
    let daily: Daily
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

struct Hourly: Codable, Hashable {
    let data: [HourlyWeather]
}

struct HourlyWeather: Codable, Hashable {
    let date: String
    let icon: Int
    let summary: String
    let temperature: Double
}

struct Daily: Codable, Hashable {
    let data: [DailyWeather]
}

struct DailyWeather: Codable, Hashable {
    let day: String
    let icon: Int
    let all_day: DayWeather
}

struct DayWeather: Codable, Hashable {
    let temperature: Double
}
