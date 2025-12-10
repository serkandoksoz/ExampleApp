//
//  DailyForecastModel.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 10.12.2025.
//
import Foundation

struct DailyForecastModel: Identifiable {
    let id = UUID()
    let date: String
    let weatherCode: Int
    let maxTemp: Double
    let minTemp: Double
    let precipitation: Double
}
