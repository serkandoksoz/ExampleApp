//
//  WeatherResponseModel.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 11.08.2025.
//
import SwiftUI
import Foundation
import CoreLocation

struct WeatherResponseModel: Codable {
    let latitude: Double
    let longitude: Double
    let current: CurrentWeatherModel
    let hourly: HourlyWeatherModel
    let daily: DailyWeatherModel
}

