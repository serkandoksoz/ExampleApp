//
//  GeocodingResponseModel.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 10.12.2025.
//
import Foundation

struct GeocodingResponseModel: Codable {
    let results: [GeocodingResultModel]?
}

struct GeocodingResultModel: Codable, Identifiable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let admin1: String?
    let admin2: String?
    
    var displayName: String {
        var components = [name]
        if let admin1 = admin1 {
            components.append(admin1)
        }
        components.append(country)
        return components.joined(separator: ", ")
    }
}
