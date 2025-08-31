//
//  DailyForecastViewModel.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 14/01/25.
//

import Foundation
import Combine

class DailyForecastViewModel: ObservableObject {
    @Published var dailyForecasts: [DailyForecast] = []
    private let apiKey = "a4b12fe621c2436ebbf75519251301" // API kalitini xavfsizroq saqlashni unutmang
    private var cancellables = Set<AnyCancellable>()
    
    struct DailyForecast: Identifiable {
        var id = UUID()
        var date: String
        var minTempC: Double
        var maxTempC: Double
        var minTempF: Double
        var maxTempF: Double
        var condition: WeatherCondition

        func temperature(isFahrenheit: Bool) -> (min: Double, max: Double) {
            if isFahrenheit {
                return (minTempF, maxTempF)
            } else {
                return (minTempC, maxTempC)
            }
        }
    }

    struct WeatherCondition {
        var icon: String
        var text: String
    }
    
    func fetchWeather() {
        // UserDefaults orqali saqlangan shaharni olish
        if let selectedCity = loadSelectedCity() {
            let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(selectedCity)&days=7" // 7 kunlik prognoz
            guard let url = URL(string: urlString) else {
                print("Invalid URL: \(urlString)")
                return
            }

            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: WeatherResponse.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Fetch completed successfully!")
                    case .failure(let error):
                        print("Fetch failed with error: \(error.localizedDescription)")
                    }
                }, receiveValue: { [weak self] response in
                    if let forecast = response.forecast {
                        self?.dailyForecasts = self?.parseDailyForecasts(forecast.forecastday) ?? []
                    }
                })
                .store(in: &cancellables)
        } else {
            print("No city found in UserDefaults")
        }
    }
    
    private func parseDailyForecasts(_ forecastDays: [WeatherResponse.ForecastData.ForecastDay]) -> [DailyForecast] {
        var forecasts: [DailyForecast] = []
        
        for day in forecastDays {
            let sfSymbolIcon = WeatherIconHelper.iconForWeatherCode(day.day.condition.icon, isDaytime: false) // SF Symbol'ni olish
            let forecast = DailyForecast(
                date: formatDate(day.date),
                minTempC: day.day.mintemp_c,
                maxTempC: day.day.maxtemp_c,
                minTempF: day.day.mintemp_f,
                maxTempF: day.day.maxtemp_f,
                condition: WeatherCondition(icon: sfSymbolIcon, text: day.day.condition.text) // Belgini o'zgartirish
            )
            forecasts.append(forecast)
        }
        
        return forecasts
    }

    private func formatDate(_ date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: date) {
            formatter.dateFormat = "EEE" // "Mon", "Tue" kabi qisqacha format
            return formatter.string(from: date)
        }
        return date
    }

    private func loadSelectedCity() -> String? {
        if let data = UserDefaults.standard.data(forKey: "selectedCity"),
           let city = try? JSONDecoder().decode(CityResponse.self, from: data) {
            return city.name // Bu yerda CityResponse'ning nomini olish kerak
        }
        return "Tashkent"
    }

    struct WeatherResponse: Decodable {
        var forecast: ForecastData?
        
        struct ForecastData: Decodable {
            var forecastday: [ForecastDay]
            
            struct ForecastDay: Decodable {
                var date: String
                var day: Day
                
                struct Day: Decodable {
                    var maxtemp_c: Double
                    var mintemp_c: Double
                    var maxtemp_f: Double
                    var mintemp_f: Double
                    var condition: Condition
                    
                    struct Condition: Decodable {
                        var text: String
                        var icon: String
                    }
                }
            }
        }
    }
}
