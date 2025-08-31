//
//  ChooseCityView.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 17/01/25.
//

import Foundation
import Combine

class CityViewModel: ObservableObject {
    @Published var cities: [CityResponse] = []
    @Published var selectedCity: CityResponse? {
        didSet {
            saveSelectedCity() // Save city when it's selected
        }
    }
    private let apiKey = "a4b12fe621c2436ebbf75519251301"

    // Fetch cities based on query
    func fetchCities(query: String) {
        guard !query.isEmpty else {
            print("Query string is empty")
            return
        }

        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.weatherapi.com/v1/search.json?key=\(apiKey)&q=\(encodedQuery)") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            print(String(data: data, encoding: .utf8) ?? "No Data")
            do {
                let cities = try JSONDecoder().decode([CityResponse].self, from: data)
                DispatchQueue.main.async {
                    self.cities = cities
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }

    // Save the selected city to UserDefaults
    func saveSelectedCity() {
        guard let city = selectedCity else { return }
        if let encoded = try? JSONEncoder().encode(city) {
            UserDefaults.standard.set(encoded, forKey: "selectedCity")
        }
    }

    // Load the selected city from UserDefaults
    func loadSelectedCity() {
        if let data = UserDefaults.standard.data(forKey: "selectedCity"),
           let city = try? JSONDecoder().decode(CityResponse.self, from: data) {
            self.selectedCity = city
        }
        
    }
}
