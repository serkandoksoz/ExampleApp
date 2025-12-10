//
//  DailyWeatherModel.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 10.12.2025.
//
import Foundation

struct DailyWeatherModel: Codable {
    let time: [String]
    let weatherCode: [Int]
    let temperature2mMax: [Double]
    let temperature2mMin: [Double]
    let precipitationSum: [Double]
    
    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case temperature2mMax = "temperature_2m_max"
        case temperature2mMin = "temperature_2m_min"
        case precipitationSum = "precipitation_sum"
    }
}
