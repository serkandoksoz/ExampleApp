//
//  DetailCard.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 10.12.2025.
//
import SwiftUI

struct DetailCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .symbolRenderingMode(.hierarchical)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding()
        .frame(height: 100)
        .background(Color.white.opacity(0.2))
        .cornerRadius(15)
    }
}
