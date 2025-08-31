//
//  AboutView.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 23/01/25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("About the App")
                .font(.title)
                .bold()
            
            Text("Simple Weather is a convenient and useful weather forecast app. It provides users with real-time weather information, temperature, wind speed, and other indicators.")
                .font(.body)
                .multilineTextAlignment(.leading)
            
            Text("About Developer")
                .font(.title2)
                .bold()
            
            VStack(alignment: .leading) {
                Text("Name: Sunnatbek")
                Text("Email: sunnatbekabdunabiyev@icloud.com")
                Text("GitHub: https://github.com/Sunnatbek077")
                Text("Telegram: https://t.me/@sunnatbekabdunabiev")
                Text("Instagram: https://www.instagram.com/the_saad_0077/")
            }
            .font(.body)
            .foregroundColor(.secondary)
            
            Spacer()
            
            Text("SAAD GROUP: 2025")
        }
        .padding()
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AboutView()
}
