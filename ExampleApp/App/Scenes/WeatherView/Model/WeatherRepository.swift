//
//  WeatherRepository.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 10.12.2025.
//

import Foundation
import Combine
import CoreLocation

struct WeatherRepository {
    private let baseURL = "https://api.open-meteo.com/v1/forecast"
    private let geocodingURL = "https://geocoding-api.open-meteo.com/v1/search"
    let logger = AppLogger(category: "WeatherRepository")
    
    // MARK: - Fetch Weather with Combine
    func fetchWeather(latitude: Double, longitude: Double) -> AnyPublisher<WeatherResponseModel, Error> {
        guard let request = createWeatherRequest(latitude: latitude, longitude: longitude) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let performer = AsyncRequestPerformer()
        return Future { promise in
            Task {
                do {
                    let result = try await performer.perform(request: request, decodeTo: WeatherResponseModel.self)
                    promise(.success(result))
                } catch let error {
                    logger.error(error)
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Fetch Weather with Async/Await
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponseModel {
        guard let request = createWeatherRequest(latitude: latitude, longitude: longitude) else {
            throw URLError(.badURL)
        }
        
        let performer = AsyncRequestPerformer()
        return try await performer.perform(request: request, decodeTo: WeatherResponseModel.self)
    }
    
    private func createWeatherRequest(latitude: Double, longitude: Double) -> URLRequest? {
        let urlString = "\(baseURL)?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,weather_code,cloud_cover,wind_speed_10m,wind_direction_10m&hourly=temperature_2m,weather_code,precipitation&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum&timezone=auto&forecast_days=7"
        
        return RequestBuilder().build(
            httpMethod: .GET,
            urlString: urlString,
            parameters: [],
            headers: [
                .accept(.json)
            ]
        )
    }
    
    // MARK: - Search Cities with Combine
    func searchCities(query: String) -> AnyPublisher<[GeocodingResultModel], Error> {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        guard let request = createCitySearchRequest(query: query) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let performer = AsyncRequestPerformer()
        return Future { promise in
            Task {
                do {
                    let result = try await performer.perform(request: request, decodeTo: GeocodingResponseModel.self)
                    promise(.success(result.results ?? []))
                } catch let error {
                    logger.error(error)
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Search Cities with Async/Await
    func searchCities(query: String) async throws -> [GeocodingResultModel] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }
        
        guard let request = createCitySearchRequest(query: query) else {
            throw URLError(.badURL)
        }
        
        let performer = AsyncRequestPerformer()
        let result = try await performer.perform(request: request, decodeTo: GeocodingResponseModel.self)
        return result.results ?? []
    }
    
    private func createCitySearchRequest(query: String) -> URLRequest? {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        return RequestBuilder().build(
            httpMethod: .GET,
            urlString: geocodingURL,
            parameters: [
                .init(key: "name", value: encodedQuery),
                .init(key: "count", value: "10"),
                .init(key: "language", value: "tr"),
                .init(key: "format", value: "json")
            ],
            headers: [
                .accept(.json)
            ]
        )
    }
}

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let logger = AppLogger(category: "LocationManager")
    
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
            logger.error("Location services disabled")
            return
        }
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            locationError = "Konum izni reddedildi. Ayarlar > Uygulama > Konum'dan izin verin."
            logger.error("Location authorization denied")
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        @unknown default:
            locationError = "Bilinmeyen konum durumu"
            logger.error("Unknown location authorization status")
        }
    }
    
    func useDefaultLocation() {
        // İstanbul koordinatları varsayılan olarak
        location = CLLocation(latitude: 41.0082, longitude: 28.9784)
        locationError = nil
        logger.info("Using default location: Istanbul")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
        locationError = nil
        logger.info("Location updated successfully")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.error(error)
        
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
            logger.info("Location authorization granted")
        case .denied, .restricted:
            locationError = "Konum izni gerekli. Ayarlar'dan izin verebilirsiniz."
            logger.error("Location authorization denied or restricted")
        case .notDetermined:
            logger.info("Location authorization not determined")
        @unknown default:
            locationError = "Bilinmeyen izin durumu"
            logger.error("Unknown authorization status")
        }
    }
}
