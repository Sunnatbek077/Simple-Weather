//  Condid.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 14/01/25.
//

import Foundation

struct Condition: Codable {
    var text: String
    var icon: String
}

//  DailyForecast.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 14/01/25.
//

import Foundation

// Kunlik prognoz uchun model
struct DailyForecast: Identifiable {
    var id = UUID()
    var date: String
    var minTemp: Double
    var maxTemp: Double
    var condition: Condition // `Condition`ni globaldan ishlatamiz
}

//  HourlyForeCast.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 14/01/25.
//

import Foundation

// Soatlik prognoz uchun model
struct HourlyForecast: Identifiable {
    var id = UUID()
    var time: String
    var temp_c: Double
    var temp_f: Double
    var condition: Condition // `Condition`ni globaldan ishlatamiz
}

//  MoonRiseResponse.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 15/01/25.
//

import Foundation

// Ma'lumotlarni olish uchun kerakli struct'lar
struct AstronomyResponse: Decodable {
    let location: Location
    let astronomy: Astronomy
}

struct Location: Decodable {
    let name: String
    let region: String
    let country: String
}

//  SunriseSunsetResponse.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 14/01/25.
//

import Foundation

struct SunriseSunsetResponse: Codable {
    var astronomy: Astronomy?
}

struct Astronomy: Codable {
    var astro: Astro?
}

struct Astro: Codable {
    var sunrise: String?
    var sunset: String?
    var moonrise: String
    var moonset: String
    var moon_illumination: Int? // Moon illumination foizda (Integer) sifatida
}

//  WeatherResponse.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 14/01/25.
//

import Foundation

struct WeatherResponse: Codable {
    var location: Location
    var current: Current
    var forecast: Forecast?  // Make this optional
    var moon: Moon?

    struct Location: Codable {
        var name: String
    }

    struct Current: Codable {
        var temp_c: Double
        var feelslike_c: Double
        var condition: Condition
        var wind_kph: Double
        var wind_mph: Double// wind_kph bo'lishi kerak
        var humidity: Int
        var wind_dir: String
        var wind_degree: Int    // Added wind direction in degrees
        var windchill_c: Double // Added windchill in Celsius
        var windchill_f: Double
        var gust_kph: Double?
        var gust_mph: Double
    }

    struct Forecast: Codable {
        var forecastday: [ForecastDay]
    }

    struct ForecastDay: Codable {
        var date: String
        var day: Day
        var astro: Astro

        struct Day: Codable {
            var maxtemp_c: Double
            var mintemp_c: Double
            
            var condition: Condition
        }

        struct Astro: Codable {
            var sunrise: String
            var sunset: String
        }
    }

    struct Moon: Codable {
        var rise: String
        var set: String
        var phase: String
        var illumination: Double
    }
}

struct CityResponse: Codable {
    var id: Int       // This corresponds to the "id" field in the JSON
    var name: String
    var region: String
    var country: String
    var lat: Double
    var lon: Double
    var url: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case region
        case country
        case lat
        case lon
        case url
    }
}
