import SwiftUI
import Combine

struct HourlyForecastView: View {
    @StateObject var viewModel = HourlyForecastViewModel()
    @AppStorage("isCelsius") private var isCelsius: Bool = true // Store temperature unit in AppStorage

    @State private var currentTime: String = ""

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(viewModel.hourlyForecasts) { forecast in
                    VStack(spacing: 10) {
                        // Format time
                        Text(formatTime(forecast.time))
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(isCurrentTime(forecast.time) ? .yellow : .white)
                        
                        // Weather icon
                        Image(systemName: mapWeatherIcon(forecast.condition.icon))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .symbolRenderingMode(.multicolor)
                        // Temperature: Celsius or Fahrenheit
                        Text("\(isCelsius ? Int(forecast.temp_c) : Int(forecast.temp_f))°\(isCelsius ? "C" : "F")")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .frame(width: 40)
                    .padding(14)
                }
            }
            .background(BlurView(style: .systemUltraThinMaterial))
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
            .cornerRadius(15)
        }
        .cornerRadius(15)
        .onAppear {
            viewModel.fetchWeather() // Fetch the 48-hour forecast
            currentTime = getCurrentTime() // Get the current time
        }
        .shadow(radius: 10)
        .padding(.horizontal, 7)
    }

    func formatTime(_ time: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.current
        if let date = formatter.date(from: time) {
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }
        return time
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

    func isCurrentTime(_ forecastTime: String) -> Bool {
        return formatTime(forecastTime) == currentTime
    }

    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        let currentDate = Date()
        return formatter.string(from: currentDate)
    }
}

#Preview {
    HourlyForecastView()
}
