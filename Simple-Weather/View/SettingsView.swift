//
//  SettingsView.swift
//  Simple-weather-app
//
//  Created by Sunnatbek on 10/01/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isCelsius") private var isCelsius: Bool = true
    @AppStorage("useSystemHourFormat") private var useSystemHourFormat: Bool = true
    @AppStorage("is12HourFormat") private var is12HourFormat: Bool = true
    @AppStorage("isKmPerHour") private var isKmPerHour: Bool = true
    
    @StateObject private var profileViewModel = ProfileViewModel()  // Profilni model qilish
    @State private var isProfileComplete: Bool = false  // Profil to'ldirilganmi
    
    let timeFormats = ["12-hour", "24-hour"]
    
    var body: some View {
        ZStack {
            NavigationStack {
                List {
                    // Harorat va vaqt formati tanlovi bir bo'limda
                    Section(header: Text("Settings")) {
                        Toggle(isOn: $isCelsius) {
                            Text(isCelsius ? "Use Celsius" : "Use Fahrenheit")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .disabled(!isProfileComplete)  // Profil to'ldirilmagan bo'lsa, o'chirib qo'yish
                        
                        Toggle(isOn: $useSystemHourFormat) {
                            Text("Use system hour")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .disabled(!isProfileComplete)  // Profil to'ldirilmagan bo'lsa, o'chirib qo'yish
                        .onChange(of: useSystemHourFormat) { oldValue, newValue in
                            if newValue {
                                is12HourFormat = isSystemUsing12HourClock()
                            }
                        }
                        
                        Toggle(isOn: $is12HourFormat) {
                            Text(is12HourFormat ? "12-hour format" : "24-hour format")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .disabled(!isProfileComplete || useSystemHourFormat)  // Profil to'ldirilmagan bo'lsa va system hour format ishlatilsa, o'chirib qo'yish
                        
                        // Tezlik birligi tanlovi
                        Toggle(isOn: $isKmPerHour) {
                            Text(isKmPerHour ? "Use km/h" : "Use mph")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .disabled(!isProfileComplete)  // Profil to'ldirilmagan bo'lsa, o'chirib qo'yish
                    }
                    
                    NavigationLink(destination: ProfileView()) {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.blue)
                            Text("Profile")
                        }
                    }
                    
                    // Profilni faollashtirish sharti
                    if isProfileComplete {
                        NavigationLink(destination: CitySearchView()) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.blue)
                                Text("Search City")
                            }
                        }
                        
                        NavigationLink(destination: LanguageSelectionView()) {
                            HStack {
                                Image(systemName: "globe")
                                    .foregroundColor(.blue)
                                Text("Language")
                            }
                        }
                        
                    } else {
                        Text("Please complete your profile to access other features.")
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Image(systemName: "person.crop.circle")
                                .foregroundStyle(.blue)
                            Text("About App and Developer")
                        }
                    }
                }
                .navigationTitle("Settings")
                .onAppear {
                    // Profilni to'ldirishni tekshirish
                    checkProfileCompletion()
                }
            }
        }
    }
    
    private func checkProfileCompletion() {
        // Profilni tekshirish
        if !profileViewModel.name.isEmpty && !profileViewModel.email.isEmpty {
            isProfileComplete = true
        } else {
            isProfileComplete = false
        }
    }
    
    private func isSystemUsing12HourClock() -> Bool {
        let formatter = DateFormatter()
        let date = Date()
        
        formatter.timeStyle = .short
        
        return formatter.string(from: date).contains("AM") || formatter.string(from: date).contains("PM")
    }
}

#Preview {
    SettingsView()
}
