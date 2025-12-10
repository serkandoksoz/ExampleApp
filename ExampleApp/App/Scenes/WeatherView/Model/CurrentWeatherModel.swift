//
//  CurrentWeatherModel.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 10.12.2025.
//
import Foundation

struct CurrentWeatherModel: Codable {
    let time: String
    let temperature2m: Double
    let relativeHumidity2m: Int
    let apparentTemperature: Double
    let isDay: Int
    let precipitation: Double
    let weatherCode: Int
    let cloudCover: Int
    let windSpeed10m: Double
    let windDirection10m: Double
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature2m = "temperature_2m"
        case relativeHumidity2m = "relative_humidity_2m"
        case apparentTemperature = "apparent_temperature"
        case isDay = "is_day"
        case precipitation
        case weatherCode = "weather_code"
        case cloudCover = "cloud_cover"
        case windSpeed10m = "wind_speed_10m"
        case windDirection10m = "wind_direction_10m"
    }
}
