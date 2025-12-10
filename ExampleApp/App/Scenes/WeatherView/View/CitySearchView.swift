//
//  CitySearchView.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 10.12.2025.
//
import SwiftUI
import Foundation
import CoreLocation

struct CitySearchView: View {
    @ObservedObject var weatherViewModel: WeatherViewModel
    @Binding var isPresented: Bool
    @State private var searchText = ""
    @FocusState private var isSearchFieldFocused: Bool
    
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
                
                VStack(spacing: 0) {
                    // Search bar
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white.opacity(0.7))
                            
                            TextField("Şehir ara (örn: Ankara, İstanbul, London)", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(.white)
                                .focused($isSearchFieldFocused)
                                .onChange(of: searchText) { newValue in
                                    Task {
                                        await weatherViewModel.searchCities(query: newValue)
                                    }
                                }
                            
                            if !searchText.isEmpty {
                                Button {
                                    searchText = ""
                                    weatherViewModel.searchResults = []
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                        
                        if let searchError = weatherViewModel.searchError {
                            Text(searchError)
                                .foregroundColor(.red.opacity(0.8))
                                .font(.caption)
                        }
                    }
                    .padding()
                    
                    // Results
                    if weatherViewModel.isSearching {
                        VStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("Şehirler aranıyor...")
                                .foregroundColor(.white.opacity(0.8))
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if weatherViewModel.searchResults.isEmpty && !searchText.isEmpty {
                        VStack(spacing: 15) {
                            Image(systemName: "location.slash")
                                .font(.system(size: 50))
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text("Şehir bulunamadı")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            Text("Farklı bir arama terimi deneyin")
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if !weatherViewModel.searchResults.isEmpty {
                        List {
                            ForEach(weatherViewModel.searchResults) { city in
                                CityRowView(city: city) {
                                    Task {
                                        await weatherViewModel.selectCity(city)
                                        isPresented = false
                                    }
                                }
                                .listRowBackground(Color.clear)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .scrollContentBackground(.hidden)
                    } else {
                        VStack(spacing: 20) {
                            Image(systemName: "globe.europe.africa")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text("Şehir Ara")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Text("Dünyanın herhangi bir yerinden hava durumu bilgilerini alın")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .navigationTitle("Şehir Ara")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        isPresented = false
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            isSearchFieldFocused = true
        }
    }
}
