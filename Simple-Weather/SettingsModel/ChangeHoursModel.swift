//
//  ChangeHoursModel.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 20/01/25.
//

import Foundation


// TimeFormatter class for formatting times based on user preference (12-hour or 24-hour)
class TimeFormatter {
    
    static func formatTime(_ timeString: String, is12HourFormat: Bool) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // Original time format from API (12-hour)
        
        if let date = formatter.date(from: timeString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = is12HourFormat ? "h:mm a" : "HH:mm" // Choose format based on setting
            return outputFormatter.string(from: date)
        }
        return timeString // Return the original time if formatting fails
    }
}
