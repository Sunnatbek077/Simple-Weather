//
//  Icons.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 22/01/25.
//


import Foundation

struct WeatherIconHelper {
    static func iconForWeatherCode(_ code: String, isDaytime: Bool) -> String {
        let iconCode = code.split(separator: "/").last?.split(separator: ".").first ?? ""
        print("Icon URL: \(code)")
        print("Extracted Icon Code: \(iconCode)")
        
        switch iconCode {
        case "113":
            // Farqlash uchun isDaytime qo'llaniladi
            if isDaytime {
                return "sun.max.fill"  // Quyosh kunduzi
            } else {
                return "moon.fill"     // Oy kechasi
            }  // Clear sky
        case "116": return "cloud.moon.fill"  // Partly cloudy
        case "119": return "cloud.fill"  // Cloudy
        case "122": return "cloud.rain.fill"  // Overcast
        case "143": return "cloud.moon.fill"  // Mist or fog at night
        case "176": return "cloud.drizzle.fill"  // Light rain
        case "179": return "cloud.rain.fill"  // Showers
        case "200": return "cloud.bolt.fill"  // Thunderstorm
        case "227": return "cloud.snow.fill"  // Snow
        case "230": return "cloud.snow.fill"  // Snow showers
        case "248": return "cloud.fog.fill"  // Fog
        case "260": return "cloud.fog.fill"  // Freezing fog
        case "263": return "cloud.rain.fill"  // Light rain showers
        case "266": return "cloud.rain.fill"  // Moderate rain showers
        case "281": return "cloud.snow.fill"  // Snow or rain
        case "284": return "cloud.snow.fill"  // Snow or rain
        case "293": return "cloud.drizzle.fill"  // Drizzle
        case "296": return "cloud.rain.fill"  // Showers
        case "299": return "cloud.rain.fill"  // Heavy showers
        case "302": return "cloud.rain.fill"  // Thunderstorms
        case "305": return "cloud.rain.fill"  // Moderate rain
        case "308": return "cloud.rain.fill"  // Heavy rain
        case "311": return "cloud.rain.fill"  // Thunderstorms with rain
        case "314": return "cloud.rain.fill"  // Heavy thunderstorm with rain
        case "317": return "cloud.snow.fill"  // Snow and rain
        case "320": return "cloud.snow.fill"  // Snow showers
        case "323": return "cloud.snow.fill"  // Snow
        case "326": return "cloud.snow.fill"  // Snow and rain showers
        case "329": return "cloud.snow.fill"  // Snow
        case "332": return "cloud.snow.fill"  // Snow showers
        case "335": return "cloud.snow.fill"  // Snow
        case "338": return "cloud.snow.fill"  // Snow
        case "350": return "cloud.snow.fill"  // Snow or sleet
        case "353": return "cloud.snow.fill"  // Snow showers
        case "356": return "cloud.snow.fill"  // Snow showers
        case "359": return "cloud.snow.fill"  // Snow showers
        case "362": return "cloud.snow.fill"  // Snow showers
        case "365": return "cloud.snow.fill"  // Snow showers
        case "368": return "cloud.snow.fill"  // Snow showers
        case "371": return "cloud.snow.fill"  // Snow showers
        case "374": return "cloud.snow.fill"  // Snow and rain
        case "377": return "cloud.snow.fill"  // Snow and rain
        case "386": return "cloud.bolt.fill"  // Thunderstorm with snow
        case "389": return "cloud.bolt.fill"  // Thunderstorm with snow
        case "392": return "cloud.bolt.fill"  // Thunderstorm with snow
        case "395": return "cloud.bolt.fill"  // Thunderstorm with snow
        default: return "cloud.sun.fill"  // Default if no match
        }
    }
}
