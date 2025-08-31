//
//  ContentView.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 10/01/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .dashboard

    enum Tab {
        case dashboard, settings
    }

    var body: some View {
        ZStack {
            // Tab bar uchun gradient fon
            VStack {
                Spacer()
                Color.blue
                .frame(height: 80)
            }
            .ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                // Dashboard
                NavigationStack {
                    DashboardView()
                }
                .tabItem {
                    Label("Dashboard", systemImage: selectedTab == .dashboard ? "house.fill" : "house")
                }
                .tag(Tab.dashboard)

                // Settings
                NavigationStack {
                    SettingsView()
                }
                .tabItem {
                    Label("Settings", systemImage: selectedTab == .settings ? "gearshape.fill" : "gearshape")
                }
                .tag(Tab.settings)
                
                
            }
            .accentColor(.customTabs) // Aktiv tab uchun rang
            
        }
    }
}

#Preview {
    ContentView()
}
