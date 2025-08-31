//
//  DashboardView.swift
//  Simple-weather-app
//
//  Created by Sunnatbek on 09/01/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var currentLocationViewModel = CurrentLocationViewModel()
    @AppStorage("isCelsius") private var isCelsius: Bool = true
    @AppStorage("isSheetPresented") private var isSheetPresented:Bool = false
    
    var body: some View {
        ZStack {
            // Fon rangi va gradient: Soft Gradient
            LinearGradient(
                gradient: Gradient(colors: [.customCyan, .customBlue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Shahar nomi
                    HStack {
                        Text(currentLocationViewModel.cityName)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .sheet(isPresented: $isSheetPresented) {
                                // Bu yerda Sheetni ko'rsatish uchun yangi kontent
                                SheetView()
                                
                            }
                        
                        
                        Button {
                            isSheetPresented.toggle()
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        
                        
                    }
                    .padding(.top, 60)
                    
                    // Ob-havo ikonkasi
                    Image(systemName: currentLocationViewModel.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .padding(.vertical, 5)
                        .symbolRenderingMode(.multicolor)
                    
                    // Hozirgi harorat
                    Text(currentLocationViewModel.temperature)
                        .font(.system(size: 64))
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: -5){
                        // Ob-havo ta'rifi
                        Text(currentLocationViewModel.weatherDescription.capitalized)
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.top, 5)
                            .opacity(0.85)
                        
                        // Feel like harorati
                        Text("Feels like: \(currentLocationViewModel.feelsLike)")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.top, 5)
                            .opacity(0.85)
                        
                        Text("MaxTemp \(currentLocationViewModel.maxTemp),  |  MinTemp \(currentLocationViewModel.minTemp)")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.top, 5)
                            .opacity(0.85)
                    }
                    // Qo'shimcha funksiyalar uchun joy (bo'sh joy)
                    HourlyForecastView()
                    
                    DailyForecastView()
                    
                    SunriseSunsetView()
                    
                    MoonrisesetView()
                    
                    WindspeedView()
                    
                    HumidityView()
                    
                    
                    
                }
            }
            
            .onAppear {
                currentLocationViewModel.fetchWeather()
            }
            .padding(.bottom, 5)
            
        }
        
        .edgesIgnoringSafeArea(.top)  // Yuqoridan bo'sh joy qoldiradi
        
    }
    
}

#Preview {
    DashboardView()
}
