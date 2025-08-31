//
//  SunriseSunsetViewModel.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 14/01/25.
//

import Foundation
import Combine
import SwiftUI


class SunriseSunsetViewModel: ObservableObject {
    @Published var sunrise: String = ""
    @Published var sunset: String = ""
    @Published var errorMessage: String?
    @Published var cityName: String = "Tashkent"  // City name will be set from CityViewModel
    @AppStorage("is12HourFormat") private var is12HourFormat: Bool = true  // Get time format setting
    @Published var isDaytime: Bool = true  // Kun yoki kechani belgilash

    private var cancellables = Set<AnyCancellable>()
    
    private let apiKey = "a4b12fe621c2436ebbf75519251301"
    private let baseURL = "https://api.weatherapi.com/v1/astronomy.json"
    
    private let cityViewModel = CityViewModel()  // CityViewModel instance
    
    init() {
        cityViewModel.loadSelectedCity()
        if let selectedCity = cityViewModel.selectedCity {
            self.cityName = selectedCity.name  // Set city name from selected city
        }
    }
    
    func fetchSunriseSunset() {
        guard let url = URL(string: "\(baseURL)?key=\(apiKey)&q=\(cityName)") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
            }
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: SunriseSunsetResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                if let sunriseTime = response.astronomy?.astro?.sunrise,
                   let sunsetTime = response.astronomy?.astro?.sunset {
                    self.sunrise = TimeFormatter.formatTime(sunriseTime, is12HourFormat: self.is12HourFormat)
                    self.sunset = TimeFormatter.formatTime(sunsetTime, is12HourFormat: self.is12HourFormat)
                    
                    // Hozirgi vaqtni olish
                    let currentTime = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    let currentTimeString = formatter.string(from: currentTime)
                    
                    // Kunmi yoki kechami ekanligini aniqlash
                    if currentTimeString >= self.sunrise && currentTimeString < self.sunset {
                        self.isDaytime = true
                    } else {
                        self.isDaytime = false
                    }
                } else {
                    self.errorMessage = "Sunrise and sunset data not found"
                }
            })
            .store(in: &cancellables)
    }
}
