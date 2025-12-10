//
//  HourlyWeatherModel.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 10.12.2025.
//
import Foundation

struct HourlyWeatherModel: Codable {
    let time: [String]
    let temperature2m: [Double]
    let weatherCode: [Int]
    let precipitation: [Double]
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature2m = "temperature_2m"
        case weatherCode = "weather_code"
        case precipitation
    }
}
