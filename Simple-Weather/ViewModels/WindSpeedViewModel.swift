//
//  WindSpeedViewModel.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 16/01/25.
//

// WindspeedViewModel.swift

// WindspeedViewModel.swift

import Foundation
import Combine

class WindspeedViewModel: ObservableObject {
    @Published var currentSpeed: Double? = nil
    @Published var gustSpeed: Double? = nil
    @Published var windDegree: Int? = nil
    @Published var windDirection: String? = nil
    @Published var windChill: Double? = nil
    @Published var isLoading: Bool = false
    @Published var error: String? = nil

    private var cancellable: AnyCancellable?
    private var cityName: String = "Tashkent"

    private let apiKey = "a4b12fe621c2436ebbf75519251301"
    private let cityViewModel = CityViewModel()

    init() {
        cityViewModel.loadSelectedCity()
        if let selectedCity = cityViewModel.selectedCity {
            self.cityName = selectedCity.name
        }
    }

    func fetchWindSpeed() {
        guard let url = URL(string: "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(cityName)") else {
            self.error = "Invalid URL"
            return
        }

        isLoading = true
        error = nil
        cancellable?.cancel()

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                switch completion {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.error = "Failed to load data: \(error.localizedDescription)"
                    }
                    print("Error:", error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] data in
                guard let self = self else { return }
                do {
                    let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.currentSpeed = decodedResponse.current.wind_kph
                        self.gustSpeed = decodedResponse.current.gust_kph
                        self.windDegree = decodedResponse.current.wind_degree
                        self.windDirection = decodedResponse.current.wind_dir
                        self.windChill = decodedResponse.current.windchill_c
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.error = "Failed to decode data: \(error.localizedDescription)"
                    }
                    print("Decoding error:", error)
                }
            })
    }

    // Convert wind chill to Fahrenheit if needed
    func windChillInFahrenheit() -> Double? {
        guard let windChillCelsius = windChill else { return nil }
        return (windChillCelsius * 9 / 5) + 32
    }

    // Convert gust speed to mph if needed
    func gustSpeedInMph() -> Double? {
        guard let gustSpeedKph = gustSpeed else { return nil }
        return gustSpeedKph * 0.621371
    }
}
