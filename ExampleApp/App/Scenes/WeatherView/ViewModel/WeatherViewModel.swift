//
//  WeatherViewModel.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 10.12.2025.
//
import SwiftUI
import Foundation
import CoreLocation
import Combine

@MainActor
final class WeatherViewModel: BaseViewModel {
    // MARK: - Published Properties
    @Published var currentWeatherModel: CurrentWeatherModel?
    @Published var hourlyForecastModels: [HourlyForecastModel] = []
    @Published var dailyForecastModels: [DailyForecastModel] = []
    @Published var cityName = "Konum Alınıyor..."
    @Published var searchResults: [GeocodingResultModel] = []
    @Published var isSearching = false
    @Published var searchError: String?
    
    // MARK: - Private Properties
    private let repository: WeatherRepository
    private let geocoder = CLGeocoder()
    
    // MARK: - Initialization
    init(repository: WeatherRepository = WeatherRepository()) {
        self.repository = repository
        super.init()
        logger = AppLogger(category: "WeatherViewModel")
    }
    
    // MARK: - Public Methods
    func loadWeather(for location: CLLocation, customCityName: String? = nil) async {
        // Get city name if not provided
        if let customName = customCityName {
            self.cityName = customName
        } else {
            getCityName(for: location)
        }
        
        // Fetch weather data using BaseViewModel's executeRestRequest
        executeRestRequest(
            repository.fetchWeather(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
        ) { [weak self] weatherResponse in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.currentWeatherModel = weatherResponse.current
                self.hourlyForecastModels = self.createHourlyForecastModels(from: weatherResponse.hourly)
                self.dailyForecastModels = self.createDailyForecastModels(from: weatherResponse.daily)
                
                self.logger.debug("Weather data loaded successfully for \(self.cityName)")
            }
        }
    }
    
    func searchCities(query: String) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        searchError = nil
        
        repository.searchCities(query: query)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isSearching = false
                
                switch completion {
                case .finished:
                    self.logger.debug("City search completed successfully.")
                case .failure(let error):
                    self.searchError = "Şehir arama hatası: \(error.localizedDescription)"
                    self.searchResults = []
                    self.logger.error(error)
                }
            }, receiveValue: { [weak self] results in
                guard let self = self else { return }
                self.searchResults = results
                self.logger.debug("Found \(results.count) cities")
            })
            .store(in: &cancellables)
    }
    
    func selectCity(_ city: GeocodingResultModel) async {
        let location = CLLocation(latitude: city.latitude, longitude: city.longitude)
        Task {
            await loadWeather(for: location, customCityName: city.displayName)
        }
        searchResults = []
    }
    
    func fetchWeatherAsync(latitude: Double, longitude: Double) async throws -> WeatherResponseModel {
        try await repository.fetchWeather(latitude: latitude, longitude: longitude)
    }
    
    // MARK: - Private Methods
    private func getCityName(for location: CLLocation) {
        Task {
            do {
                let placemarks = try await geocoder.reverseGeocodeLocation(location)
                await MainActor.run {
                    if let placemark = placemarks.first {
                        self.cityName = placemark.locality ?? placemark.administrativeArea ?? "Bilinmeyen Konum"
                    }
                }
            } catch {
                await MainActor.run {
                    self.cityName = "Konum Alınamadı"
                }
                self.logger.error(error)
            }
        }
    }
    
    private func createHourlyForecastModels(from hourly: HourlyWeatherModel) -> [HourlyForecastModel] {
        let count = min(24, hourly.time.count) // Next 24 hours
        return (0..<count).compactMap { index in
            let timeString = hourly.time[index]
            let formatter = ISO8601DateFormatter()
            if let date = formatter.date(from: timeString) {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                return HourlyForecastModel(
                    time: timeFormatter.string(from: date),
                    temperature: hourly.temperature2m[index],
                    weatherCode: hourly.weatherCode[index],
                    precipitation: hourly.precipitation[index]
                )
            }
            return nil
        }
    }
    
    private func createDailyForecastModels(from daily: DailyWeatherModel) -> [DailyForecastModel] {
        return (0..<daily.time.count).compactMap { index in
            let dateString = daily.time[index]
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let date = formatter.date(from: dateString) {
                let displayFormatter = DateFormatter()
                displayFormatter.dateFormat = "EEE"
                displayFormatter.locale = Locale(identifier: "tr_TR")
                return DailyForecastModel(
                    date: displayFormatter.string(from: date),
                    weatherCode: daily.weatherCode[index],
                    maxTemp: daily.temperature2mMax[index],
                    minTemp: daily.temperature2mMin[index],
                    precipitation: daily.precipitationSum[index]
                )
            }
            return nil
        }
    }
}
