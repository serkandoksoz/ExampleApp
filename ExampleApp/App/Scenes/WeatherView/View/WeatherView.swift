//
//  WeatherView.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 10.12.2025.
//
import SwiftUI
import Foundation
import CoreLocation

struct WeatherScreen: Route {}

struct WeatherView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var weatherViewModel = WeatherViewModel()
    @State private var showingSearch = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        if weatherViewModel.isLoading {
                            ProgressView("Hava durumu yükleniyor...")
                                .foregroundColor(.white)
                                .padding(.top, 100)
                        } else if let errorMessage = weatherViewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red.opacity(0.3))
                                .cornerRadius(10)
                        } else if let CurrentWeatherModel = weatherViewModel.currentWeatherModel {
                            VStack(spacing: 20) {
                                CurrentWeatherModelView(
                                    weather: CurrentWeatherModel,
                                    cityName: weatherViewModel.cityName
                                )
                                
                                HourlyForecastModelView(forecasts: weatherViewModel.hourlyForecastModels)
                                
                                DailyForecastModelView(forecasts: weatherViewModel.dailyForecastModels)
                                
                                WeatherDetailsView(weather: CurrentWeatherModel)
                            }
                        } else {
                            VStack(spacing: 20) {
                                Image(systemName: locationManager.locationError != nil ? "location.slash.circle" : "location.circle")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white)
                                
                                Text(locationManager.locationError != nil ? "Konum Sorunu" : "Konum İzni Gerekli")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                if let locationError = locationManager.locationError {
                                    Text(locationError)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white.opacity(0.8))
                                        .padding(.horizontal)
                                } else {
                                    Text("Hava durumu bilgilerini görmek için konum izni verin")
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white.opacity(0.8))
                                        .padding(.horizontal)
                                }
                                
                                VStack(spacing: 12) {
                                    Button("Konum İzni Ver") {
                                        locationManager.requestLocation()
                                    }
                                    .buttonStyle(PrimaryButtonStyle())
                                    
                                    Button("Varsayılan Konum Kullan (İstanbul)") {
                                        locationManager.useDefaultLocation()
                                    }
                                    .buttonStyle(SecondaryButtonStyle())
                                    
                                    Button("Şehir Ara") {
                                        showingSearch = true
                                    }
                                    .buttonStyle(SecondaryButtonStyle())
                                }
                            }
                            .padding(.top, 100)
                        }
                    }
                    .padding()
                }
                .refreshable {
                    if let location = locationManager.location {
                        await weatherViewModel.loadWeather(for: location)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSearch = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        locationManager.requestLocation()
                    } label: {
                        Image(systemName: "location")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
        .onChange(of: locationManager.location) { oldValue, newValue in
            if let location = newValue {
                Task {
                    await weatherViewModel.loadWeather(for: location)
                }
            }
        }
        .sheet(isPresented: $showingSearch) {
            CitySearchView(weatherViewModel: weatherViewModel, isPresented: $showingSearch)
        }
    }
}

#Preview {
    WeatherView()
}
