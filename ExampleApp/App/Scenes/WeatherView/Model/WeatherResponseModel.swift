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

// MARK: - Weather Service
/*class WeatherService: ObservableObject {
    private let baseURL = "https://api.open-meteo.com/v1/forecast"
    private let geocodingURL = "https://geocoding-api.open-meteo.com/v1/search"
    
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponseModel {
        let urlString = "\(baseURL)?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,weather_code,cloud_cover,wind_speed_10m,wind_direction_10m&hourly=temperature_2m,weather_code,precipitation&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum&timezone=auto&forecast_days=7"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let weatherResponse = try JSONDecoder().decode(WeatherResponseModel.self, from: data)
        return weatherResponse
    }
    
    func searchCities(query: String) async throws -> [GeocodingResultModel] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(geocodingURL)?name=\(encodedQuery)&count=10&language=tr&format=json"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let geocodingResponse = try JSONDecoder().decode(GeocodingResponseModel.self, from: data)
        return geocodingResponse.results ?? []
    }
}

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationError: String?
    @Published var isLocationEnabled: Bool = true
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = locationManager.authorizationStatus
        checkLocationServices()
    }
    
    private func checkLocationServices() {
        isLocationEnabled = CLLocationManager.locationServicesEnabled()
    }
    
    func requestLocation() {
        locationError = nil
        
        guard isLocationEnabled else {
            locationError = "Konum servisleri kapalı. Ayarlar > Gizlilik ve Güvenlik > Konum Servisleri'nden açın."
            return
        }
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            locationError = "Konum izni reddedildi. Ayarlar > Uygulama > Konum'dan izin verin."
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        @unknown default:
            locationError = "Bilinmeyen konum durumu"
        }
    }
    
    func useDefaultLocation() {
        // İstanbul koordinatları varsayılan olarak
        location = CLLocation(latitude: 41.0082, longitude: 28.9784)
        locationError = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
        locationError = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                locationError = "Konum izni reddedildi"
            case .locationUnknown:
                locationError = "Konum belirlenemiyor"
            case .network:
                locationError = "Ağ hatası - konum alınamıyor"
            default:
                locationError = "Konum hatası: \(error.localizedDescription)"
            }
        } else {
            locationError = "Bilinmeyen konum hatası"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        locationError = nil
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            locationError = "Konum izni gerekli. Ayarlar'dan izin verebilirsiniz."
        case .notDetermined:
            break
        @unknown default:
            locationError = "Bilinmeyen izin durumu"
        }
    }
}*/

