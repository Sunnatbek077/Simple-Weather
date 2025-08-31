//
//  HumidityViewModel.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 16/01/25.
//

import Foundation
import Combine


class HumidityViewModel: ObservableObject {
    @Published var humidity: String = "Loading..."
    @Published var isLoading: Bool = true
    @Published var errorMessage: String? = nil
    
    private let weatherAPIKey = "a4b12fe621c2436ebbf75519251301"
    private var city: String = "Tashkent"  // Shahar nomini `loadSelectedCity` dan olamiz
    
    private let cityViewModel = CityViewModel()  // CityViewModel instance
    
    init() {
        cityViewModel.loadSelectedCity()
        if let selectedCity = cityViewModel.selectedCity {
            self.city = selectedCity.name  // Tanlangan shahar nomini olish
        }
        fetchHumidityData()
    }
    
    func fetchHumidityData() {
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(weatherAPIKey)&q=\(city)"
        
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                    self.isLoading = false
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    self.humidity = "\(weatherData.current.humidity)%"
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode data"
                    self.isLoading = false
                }
            }
        }.resume()
    }
}
