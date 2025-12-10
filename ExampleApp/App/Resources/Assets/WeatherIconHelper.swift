//
//  WeatherIconHelper.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 10.12.2025.
//


struct WeatherIconHelper {
    static func icon(for weatherCode: Int, isDay: Bool = true) -> String {
        switch weatherCode {
        case 0: return isDay ? "sun.max.fill" : "moon.stars.fill"
        case 1, 2, 3: return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
        case 45, 48: return "cloud.fog.fill"
        case 51, 53, 55: return "cloud.drizzle.fill"
        case 56, 57: return "cloud.sleet.fill"
        case 61, 63, 65: return "cloud.rain.fill"
        case 66, 67: return "cloud.sleet.fill"
        case 71, 73, 75: return "cloud.snow.fill"
        case 77: return "cloud.snow.fill"
        case 80, 81, 82: return "cloud.heavyrain.fill"
        case 85, 86: return "cloud.snow.fill"
        case 95: return "cloud.bolt.rain.fill"
        case 96, 99: return "cloud.bolt.rain.fill"
        default: return isDay ? "sun.max.fill" : "moon.stars.fill"
        }
    }
    
    static func description(for weatherCode: Int) -> String {
        switch weatherCode {
        case 0: return "Açık"
        case 1: return "Çoğunlukla Açık"
        case 2: return "Parçalı Bulutlu"
        case 3: return "Bulutlu"
        case 45, 48: return "Sisli"
        case 51, 53, 55: return "Çiseleyen"
        case 56, 57: return "Dondurucu Çiseleme"
        case 61: return "Hafif Yağmur"
        case 63: return "Orta Yağmur"
        case 65: return "Şiddetli Yağmur"
        case 66, 67: return "Dondurucu Yağmur"
        case 71, 73, 75: return "Kar Yağışı"
        case 77: return "Kar Tanesi"
        case 80, 81, 82: return "Sağanak Yağmur"
        case 85, 86: return "Kar Sağanağı"
        case 95: return "Gök Gürültülü Fırtına"
        case 96, 99: return "Şiddetli Fırtına"
        default: return "Bilinmeyen"
        }
    }
}