//
//  String+Ext.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 22.11.2024.
//

import UIKit

import UIKit

extension String {
    /// Converts a string with optional non-numeric characters to CGFloat
    func toCGFloat() -> CGFloat? {
        if let numericValue = self.extractNumericPart() {
            return CGFloat(numericValue)
        }
        return nil
    }
    
    /// Converts a string with optional non-numeric characters to Double
    func toDouble() -> Double? {
        return extractNumericPart()
    }
    
    /// Converts a string with optional non-numeric characters to Float
    func toFloat() -> Float? {
        if let numericValue = self.extractNumericPart() {
            return Float(numericValue)
        }
        return nil
    }
    
    /// Converts a string with optional non-numeric characters to Int
    func toInt() -> Int? {
        if let numericValue = self.extractNumericPart() {
            return Int(numericValue)
        }
        return nil
    }
    
    /// Helper function to extract the numeric part of the string
    private func extractNumericPart() -> Double? {
        // Use regex to extract numeric characters
        let pattern = "[0-9.]+"
        if let range = self.range(of: pattern, options: .regularExpression) {
            let numericString = String(self[range])
            return Double(numericString)
        }
        return nil
    }
}

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    
    if Calendar.current.isDateInToday(date) {
        formatter.dateFormat = "HH:mm"
    } else if Calendar.current.isDateInYesterday(date) {
        return "Dün"
    } else {
        formatter.dateFormat = "dd.MM.yyyy"
    }
    
    return formatter.string(from: date)
}

extension String {
    func toDisplayDate(format: String = "dd.MM.yyyy HH:mm", locale: Locale = .current) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = isoFormatter.date(from: self) else { return self }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = format
        displayFormatter.locale = locale
        
        return displayFormatter.string(from: date)
    }
    
    func toDateFromISO8601() -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return isoFormatter.date(from: self)
    }
    
    func toDisplayDate2(format: String = "d MMM yyyy, HH:mm") -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        var date = isoFormatter.date(from: self)
        
        if date == nil {
            isoFormatter.formatOptions = [.withInternetDateTime]
            date = isoFormatter.date(from: self)
        }
        
        guard let validDate = date else {
            return self
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = format
        return formatter.string(from: validDate)
    }
    func toDisplayDate3() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: self) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM yyyy - h:mm a"
        outputFormatter.locale = Locale(identifier: "en_US")
        outputFormatter.amSymbol = "am"
        outputFormatter.pmSymbol = "pm"
        
        let formattedString = outputFormatter.string(from: date).uppercased()
        
        return formattedString
    }
    
}

extension Array {
    func partitioned(by condition: (Element) -> Bool) -> ([Element], [Element]) {
        var matching = [Element]()
        var nonMatching = [Element]()
        for element in self {
            if condition(element) {
                matching.append(element)
            } else {
                nonMatching.append(element)
            }
        }
        return (matching, nonMatching)
    }
}

extension String {
    func toISODateTime(with date: String) -> String? {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let time = timeFormatter.date(from: self) else {
            return nil
        }
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        
        return "\(date)T\(String(format: "%02d:%02d:00", hour, minute))"
    }
    
    func toHourMinuteAMPM() -> String? {
        let isoFormatter = DateFormatter()
        isoFormatter.locale = Locale(identifier: "en_US_POSIX")
        isoFormatter.timeZone = TimeZone.current
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let date = isoFormatter.date(from: self) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.dateFormat = "h:mm a"
        
        return outputFormatter.string(from: date)
    }
}
