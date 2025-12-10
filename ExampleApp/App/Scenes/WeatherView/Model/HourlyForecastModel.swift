//
//  HourlyForecastModel.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 10.12.2025.
//
import Foundation

struct HourlyForecastModel: Identifiable {
    let id = UUID()
    let time: String
    let temperature: Double
    let weatherCode: Int
    let precipitation: Double
}
