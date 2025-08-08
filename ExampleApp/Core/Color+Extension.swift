//
//  Color+Extension.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 18.12.2024.
//

import SwiftUI

extension Color {
    /// Initializes a Color from a hex string.
    /// - Parameter hex: The hex string in the format `#RRGGBB` or `#RRGGBBAA`.
    init?(hex: String) {
        var sanitizedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Remove # if it exists
        if sanitizedHex.hasPrefix("#") {
            sanitizedHex.remove(at: sanitizedHex.startIndex)
        }
        
        // Ensure valid length
        guard sanitizedHex.count == 6 || sanitizedHex.count == 8 else { return nil }
        
        var rgbValue: UInt64 = 0
        Scanner(string: sanitizedHex).scanHexInt64(&rgbValue)
        
        // Extract color components
        let r, g, b, a: Double
        if sanitizedHex.count == 8 {
            r = Double((rgbValue & 0xFF000000) >> 24) / 255.0
            g = Double((rgbValue & 0x00FF0000) >> 16) / 255.0
            b = Double((rgbValue & 0x0000FF00) >> 8) / 255.0
            a = Double(rgbValue & 0x000000FF) / 255.0
        } else {
            r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
            g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
            b = Double(rgbValue & 0x0000FF) / 255.0
            a = 1.0
        }
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
