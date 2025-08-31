//
//  CurrentLocationViewModel.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 12/01/25.
//
import Foundation
import SwiftUI
import Combine

final class CurrentLocationViewModel: ObservableObject {
    @AppStorage("isCelsius") private var isCelsius: Bool = true
    @Published var cityName: String = "Tashkent"
    @Published var temperature: String = "0°C"
    @Published var maxTemp: String = "0°C"
    @Published var minTemp: String = "0°C"
    @Published var feelsLike: String = "0°C"
    @Published var weatherDescription: String = "Clear sky"
    @Published var icon: String = "cloud.sun.fill"
    @Published var saveCity: CityResponse?
    private let apiKey = "a4b12fe621c2436ebbf75519251301"

    // Load saved city when the view model is initialized
    init() {
        loadSavedCity()
    }

    // Load saved city from UserDefaults
    func loadSavedCity() {
        if let data = UserDefaults.standard.data(forKey: "selectedCity"),
           let city = try? JSONDecoder().decode(CityResponse.self, from: data) {
            self.saveCity = city
            self.cityName = city.name // Update the cityName with saved city
        }
    }

    // Fetch weather using saved or default city
    func fetchWeather(for city: String? = nil) {
        let cityToFetch = city ?? self.cityName
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(cityToFetch)&days=1"
        guard let url = URL(string: urlString) else { return }
        
        // Network request
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching weather: \(error)")
                return
            }

            if let data = data {
                do {
                    // Decode JSON response
                    let weatherData = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    DispatchQueue.main.async {
                        // Update UI on main thread
                        self?.updateWeatherData(with: weatherData)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else {
                print("No data received")
            }
        }.resume()
    }

    // Update weather data
    private func updateWeatherData(with weatherData: WeatherResponse) {
        cityName = weatherData.location.name
        
        // Temperature conversions
        let currentTemp = weatherData.current.temp_c
        let maxTempC = weatherData.forecast?.forecastday[0].day.maxtemp_c ?? 0
        let minTempC = weatherData.forecast?.forecastday[0].day.mintemp_c ?? 0
        let feelsLikeC = weatherData.current.feelslike_c
        
        temperature = "\(Int(convertTemperature(currentTemp)))°\(unitSymbol)"
        maxTemp = "\(Int(convertTemperature(maxTempC)))°\(unitSymbol)"
        minTemp = "\(Int(convertTemperature(minTempC)))°\(unitSymbol)"
        feelsLike = "\(Int(convertTemperature(feelsLikeC)))°\(unitSymbol)"
        
        weatherDescription = weatherData.current.condition.text
        icon = WeatherIconHelper.iconForWeatherCode(weatherData.current.condition.icon, isDaytime: true)
    }

    // Convert temperature based on user preference
    private func convertTemperature(_ celsius: Double) -> Double {
        return TemperatureService.convertTemperature(celsius, toCelsius: isCelsius)
    }

    // Get the unit symbol
    private var unitSymbol: String {
        return isCelsius ? "C" : "F"
    }
}
