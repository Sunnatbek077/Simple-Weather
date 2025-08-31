import Foundation
import Combine

class HourlyForecastViewModel: ObservableObject {
    @Published var hourlyForecasts: [Forecast] = []
    @Published var isCelsius = true  // Haroratni Celsius yoki Fahrenheitda ko'rsatish
    private let apiKey = "a4b12fe621c2436ebbf75519251301" // API kalitingizni xavfsizroq saqlashni unutmang
    private var cancellables = Set<AnyCancellable>()

    struct Forecast: Identifiable {
        var id = UUID()
        var time: String
        var temp_c: Double
        var temp_f: Double
        var condition: WeatherCondition
    }

    struct WeatherCondition {
        var icon: String
        var text: String
    }

    func fetchWeather() {
        if let selectedCity = loadSelectedCity() {
            let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(selectedCity)&days=2"
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
                        let allForecasts = self?.parseForecasts(forecast.forecastday.flatMap { $0.hour }) ?? []
                        self?.hourlyForecasts = self?.filter24HourForecasts(from: allForecasts) ?? []
                        print("Filtered Hourly Forecasts: \(self?.hourlyForecasts ?? [])")
                    }
                })
                .store(in: &cancellables)
        } else {
            print("No city found in UserDefaults")
        }
    }

    private func filter24HourForecasts(from forecasts: [Forecast]) -> [Forecast] {
        let currentDate = Date()
        let calendar = Calendar.current

        // Filter today's and tomorrow's forecasts
        let todayForecasts = forecasts.filter { forecast in
            if let date = parseDate(forecast.time) {
                return calendar.isDateInToday(date)
            }
            return false
        }

        let tomorrowForecasts = forecasts.filter { forecast in
            if let date = parseDate(forecast.time) {
                return calendar.isDateInTomorrow(date)
            }
            return false
        }

        // Get remaining hours of today starting from the current hour
        let currentHour = calendar.component(.hour, from: currentDate)
        let remainingToday = todayForecasts.filter { forecast in
            if let date = parseDate(forecast.time) {
                let hour = calendar.component(.hour, from: date)
                return hour >= currentHour
            }
            return false
        }

        // Calculate how many forecasts are needed from tomorrow
        let totalNeeded = 24
        let neededFromTomorrow = totalNeeded - remainingToday.count

        // Combine today's and tomorrow's forecasts
        return Array(remainingToday.prefix(24)) + Array(tomorrowForecasts.prefix(neededFromTomorrow))
    }

    private func parseForecasts(_ hours: [WeatherResponse.ForecastData.ForecastDay.Hour]) -> [Forecast] {
        var forecasts: [Forecast] = []

        for hour in hours {
            let tempF = (hour.temp_c * 9 / 5) + 32
            let sfSymbolIcon = WeatherIconHelper.iconForWeatherCode(hour.condition.icon, isDaytime: false)
            let forecast = Forecast(
                time: hour.time,
                temp_c: hour.temp_c,
                temp_f: tempF,
                condition: WeatherCondition(icon: sfSymbolIcon, text: hour.condition.text)
            )
            forecasts.append(forecast)
        }

        return forecasts
    }

    private func parseDate(_ time: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter.date(from: time)
    }

    private func loadSelectedCity() -> String? {
        if let data = UserDefaults.standard.data(forKey: "selectedCity"),
           let city = try? JSONDecoder().decode(CityResponse.self, from: data) {
            return city.name
        }
        return "Tashkent"
    }

    func toggleTemperatureUnit() {
        isCelsius.toggle()
    }

    struct WeatherResponse: Decodable {
        var forecast: ForecastData?

        struct ForecastData: Decodable {
            var forecastday: [ForecastDay]

            struct ForecastDay: Decodable {
                var hour: [Hour]

                struct Hour: Decodable {
                    var time: String
                    var temp_c: Double
                    var condition: Condition

                    struct Condition: Decodable {
                        var icon: String
                        var text: String
                    }
                }
            }
        }
    }
}
