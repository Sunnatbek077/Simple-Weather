//
//  WeatherDayView.swift
//  Simple-weather-app
//
//  Created by Sunnatbek on 09/01/25.
//

import SwiftUI

struct DailyForecastView: View {
    @StateObject var viewModel = DailyForecastViewModel()
    @AppStorage("isCelsius") private var isCelsius: Bool = true // Default value

    var body: some View {
        VStack(spacing: 20) {
            // Header qismi
            ScrollView {
                VStack {
                    HStack {
                        Text("7 Day Forecast")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundStyle(Color.white)
                            .padding()
                        Spacer()
                    }
                    ForEach(viewModel.dailyForecasts) { forecast in
                        Divider()
                            .frame(height: 2)
                            .background(Color.gray.opacity(0.3))
                            .padding(.horizontal)

                        HStack(spacing: 5) {
                            // Sana va ob-havo holati
                            HStack {
                                Text(forecast.date)
                                    .font(.system(size: 20, weight: .bold, design: .default))
                                    .foregroundStyle(Color.white)
                                    .frame(width: 84)

                                Image(systemName: mapWeatherIcon(forecast.condition.icon))
                                    .symbolRenderingMode(.multicolor)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30)
                                Spacer()
                            }

                            // Haroratlar
                            Text("\(Int(isCelsius ? forecast.temperature(isFahrenheit: false).min : forecast.temperature(isFahrenheit: true).min))°")
                                .foregroundStyle(Color.white)

                            // Harorat chizig'i
                            GeometryReader { geometry in
                                let lineWidth = geometry.size.width
                                let position = lineWidth / 2 // Harorat o'qi uchun dinamik joylashuvni sozlashingiz mumkin

                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.blue, .red.opacity(0.5)]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(height: 4)

                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 10, height: 10)
                                        .offset(x: max(0, min(position - 5, lineWidth - 10)))
                                        .animation(.easeInOut(duration: 0.8), value: position)
                                }
                                
                            }
                            .padding()
                            .frame(width: 140)

                            // Maksimal harorat
                            Text("\(Int(isCelsius ? forecast.temperature(isFahrenheit: false).max : forecast.temperature(isFahrenheit: true).max))°")
                                .foregroundStyle(Color.white)
                                .font(.system(size: 22))
                                .bold()
                        }
                        .padding(.vertical, 7)
                        .padding(.horizontal)
                    }
                }
                .background(BlurView(style: .systemUltraThinMaterial))
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                .cornerRadius(15)
            }
            .shadow(radius: 10)
            .padding(.horizontal, 7)
        }
        .onAppear {
            viewModel.fetchWeather()
        }
        
    }

    func mapWeatherIcon(_ iconURL: String) -> String {
        if iconURL.contains("day") {
            return "sun.max.fill"
        } else if iconURL.contains("night") {
            return "moon.stars.fill"
        } else if iconURL.contains("rain") {
            return "cloud.rain.fill"
        } else if iconURL.contains("snow") {
            return "snowflake"
        } else {
            return "cloud.fill"
        }
    }
}

#Preview {
    DailyForecastView()
}
