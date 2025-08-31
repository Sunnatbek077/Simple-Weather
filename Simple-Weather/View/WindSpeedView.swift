//
//  WindSpeedView.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 16/01/25.
//
// WindspeedView.swift

import SwiftUI

struct WindspeedView: View {
    @StateObject var viewModel = WindspeedViewModel()  // Using @StateObject for the view model
    @AppStorage("isCelsius") private var isCelsius: Bool = true // Default value for temperature units (Celsius or Fahrenheit)
    @AppStorage("isKmPerHour") private var isKmPerHour: Bool = true // Default value for wind speed units (km/h or mph)

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    
                    HStack {
                        Text("Current Wind Speed:")
                            .font(.body)
                            .bold()
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                        
                        // Current Wind Speed (km/h or mph)
                        if let speed = viewModel.currentSpeed {
                            Text("\(speed, specifier: "%.1f") \(isKmPerHour ? "km/h" : "mph")")
                                .font(.body)
                                .bold()
                                .foregroundStyle(Color.white)
                        } else if viewModel.isLoading {
                            ProgressView("Loading...")
                                .progressViewStyle(CircularProgressViewStyle())
                        } else if let error = viewModel.error {
                            Text(error)
                                .foregroundColor(.red)
                                .bold()
                                .font(.body)
                        } else {
                            Text("Failed to load wind speed")
                                .foregroundColor(.red)
                        }
                    }
                    
                    HStack {
                        Text("Wind Gust:")
                            .font(.body)
                            .bold()
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                        
                        // Wind Gust (km/h or mph)
                        if let gustSpeed = isKmPerHour ? viewModel.gustSpeed : viewModel.gustSpeedInMph() {
                            Text("\(gustSpeed, specifier: "%.1f") \(isKmPerHour ? "km/h" : "mph")")
                                .font(.body)
                                .bold()
                                .foregroundStyle(Color.white)
                        } else if !viewModel.isLoading {
                            Text("No gust data available.")
                                .font(.body)
                                .bold()
                                .foregroundStyle(.red)
                        }

                    }
                    
                    HStack {
                        Text("Direction:")
                            .font(.body)
                            .bold()
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                        
                        // Display Wind Direction
                        if let windDegree = viewModel.windDegree, let windDirection = viewModel.windDirection {
                            Text("\(windDirection) (\(windDegree)°)")
                                .font(.body)
                                .bold()
                                .foregroundStyle(Color.white)
                        }
                    }
                    
                    HStack {
                        Text("Wind Chill:")
                            .font(.body)
                            .bold()
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                        
                        // Display Wind Chill (Celsius or Fahrenheit)
                        if let windChill = isCelsius ? viewModel.windChill : viewModel.windChillInFahrenheit() {
                            Text("\(windChill, specifier: "%.1f")\(isCelsius ? "°C" : "°F")")
                                .font(.body)
                                .bold()
                                .foregroundStyle(Color.white)
                        }
                    }
                    
                    
                }
                .padding()

            }
            .background(BlurView(style: .systemUltraThinMaterial))
            .cornerRadius(15)
            .shadow(radius: 10)
            .onAppear {
                viewModel.fetchWindSpeed()
            }
            .padding(.horizontal, 7)
        }
    }
}

#Preview {
    WindspeedView()
}
