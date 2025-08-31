//
//  CitySearchView.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 17/01/25.
//

import SwiftUI

struct CitySearchView: View {
    @StateObject private var viewModel = CityViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter City name", text: $searchText)
                    .onSubmit {
                        viewModel.fetchCities(query: searchText)
                    }
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                List(viewModel.cities, id: \.id) { city in
                    VStack(alignment: .leading) {
                        Text(city.name)
                            .font(.headline)
                        Text("\(city.region), \(city.country)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        viewModel.selectedCity = city // Update selected city when tapped
                        print("Selected city: \(city.name)")
                    }
                }
                
                if viewModel.cities.isEmpty {
                    Text("No cities found. Please try again.")
                        .foregroundColor(.red)
                        .padding()
                }
                
                if let selectedCity = viewModel.selectedCity {
                    Text("Selected City: \(selectedCity.name), \(selectedCity.region), \(selectedCity.country)")
                        .padding()
                        .font(.title2)
                        .foregroundColor(.green)
                } else {
                    Text("No city selected")
                        .padding()
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                
                // Save button
                Button(action: {
                    viewModel.saveSelectedCity() // Save city to UserDefaults
                }) {
                    Text("Save City")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
            }
            .padding()
            .onAppear {
                viewModel.loadSelectedCity() // Load the selected city when the view appears
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.headline)
                        Text("Search City")
                        
                    }
                }
            }
        }
        
    }
}

#Preview {
    CitySearchView()
}
