//
//  MoonrisesetViewModel.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 15/01/25.
//

import Foundation
import Combine
import SwiftUI

class MoonrisesetViewModel: ObservableObject {
    @Published var moonriseTime: String = ""
    @Published var moonsetTime: String = ""
    @Published var moonIllumination: Int? = nil  // Moon illumination in percentage (Integer)
    @Published var location: String = ""
    
    @AppStorage("is12HourFormat") private var is12HourFormat: Bool = true  // Access time format setting
    
    private var cancellables = Set<AnyCancellable>()
    
    private let apiKey = "a4b12fe621c2436ebbf75519251301"
    private var cityName: String = "Tashkent" // Get the city name from CityViewModel
    
    private let cityViewModel = CityViewModel()  // CityViewModel instance
    
    init() {
        cityViewModel.loadSelectedCity()
        if let selectedCity = cityViewModel.selectedCity {
            self.cityName = selectedCity.name  // Get selected city name
        }
    }
    
    // Create the API URL
    private func createAPIURL() -> URL? {
        let urlString = "https://api.weatherapi.com/v1/astronomy.json?key=\(apiKey)&q=\(cityName)&dt=\(getCurrentDate())"
        return URL(string: urlString)
    }
    
    // Get current date in format yyyy-MM-dd
    private func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }

    // Fetch moonrise, moonset, and illumination data from the API
    func fetchMoonrisesetData() {
        guard let url = createAPIURL() else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: AstronomyResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Data fetched successfully")
                case .failure(let error):
                    print("Error fetching data: \(error)")
                }
            }, receiveValue: { [weak self] data in
                // Process the moonrise and moonset data
                if let moonrise = data.astronomy.astro?.moonrise,
                   let moonset = data.astronomy.astro?.moonset {
                    self?.moonriseTime = TimeFormatter.formatTime(moonrise, is12HourFormat: self?.is12HourFormat ?? true)
                    self?.moonsetTime = TimeFormatter.formatTime(moonset, is12HourFormat: self?.is12HourFormat ?? true)
                } else {
                    self?.moonriseTime = "N/A"
                    self?.moonsetTime = "N/A"
                }
                self?.moonIllumination = data.astronomy.astro?.moon_illumination
                self?.location = "\(data.location.name), \(data.location.country)"
            })
            .store(in: &cancellables)
    }
}
