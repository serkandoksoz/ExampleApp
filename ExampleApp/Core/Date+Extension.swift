//
//  Date+Extension.swift
//  Weddy
//
//  Created by Serkan Doksöz on 7.05.2025.
//

import Foundation

// MARK: - Date Extensions
extension Date {
    // Convert timestamp to date string with desired format
    func toString(format: String = "dd MMM yyyy, HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    // Get time ago string (e.g. "2 minutes ago", "1 hour ago")
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: self, to: now, options: [])
        
        if let year = components.year, year >= 1 {
            return year == 1 ? "1 year ago" : "\(year) years ago"
        }
        
        if let month = components.month, month >= 1 {
            return month == 1 ? "1 month ago" : "\(month) months ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return week == 1 ? "1 week ago" : "\(week) weeks ago"
        }
        
        if let day = components.day, day >= 1 {
            return day == 1 ? "1 day ago" : "\(day) days ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return hour == 1 ? "1 hour ago" : "\(hour) hours ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return minute == 1 ? "1 minute ago" : "\(minute) minutes ago"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) seconds ago"
        }
        
        return "Just now"
    }
}

// MARK: - Int and Int64 Extensions for Timestamp Conversion
extension Int64 {
    // Convert millisecond timestamp to Date
    var dateFromMillisecondTimestamp: Date {
        return Date(timeIntervalSince1970: TimeInterval(self) / 1000)
    }
    
    // Convert second timestamp to Date
    var dateFromSecondTimestamp: Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
    
    // Auto detect if timestamp is in seconds or milliseconds and convert to Date
    var dateValue: Date {
        // If timestamp is in milliseconds (has 13 digits)
        if self > 1_000_000_000_000 {
            return dateFromMillisecondTimestamp
        } else {
            return dateFromSecondTimestamp
        }
    }
}

// Same extension for Int type
extension Int {
    var dateFromMillisecondTimestamp: Date {
        return Date(timeIntervalSince1970: TimeInterval(self) / 1000)
    }
    
    var dateFromSecondTimestamp: Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
    
    var dateValue: Date {
        if self > 1_000_000_000_000 {
            return dateFromMillisecondTimestamp
        } else {
            return dateFromSecondTimestamp
        }
    }
}

// MARK: - Usage Examples
/*
// Example usage:
let timestamp: Int64 = 1745423983634
let date = timestamp.dateFromMillisecondTimestamp

// Or using auto-detection:
let autoDetectDate = timestamp.dateValue

// Format date to string
let dateString = date.toString(format: "dd MMM yyyy, HH:mm")

// Get time ago
let timeAgo = date.timeAgoDisplay()
*/
