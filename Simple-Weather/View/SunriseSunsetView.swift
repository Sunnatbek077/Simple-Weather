//
//  SunriseSunsetView.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 14/01/25.
//

import SwiftUI

struct SunriseSunsetView: View {
    @StateObject var viewModel = SunriseSunsetViewModel()

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                if let errorMessage = viewModel.errorMessage {
                    HStack {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.headline)
                        
                        Spacer()
                    }
                    .padding()
                    .background(BlurView(style: .systemUltraThinMaterial))
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    
                } else if viewModel.sunrise.isEmpty || viewModel.sunset.isEmpty {
                    ProgressView("Loading...")
                        .foregroundColor(.white)
                        .font(.headline)
                } else {
                    VStack{
                        InfoCardView(
                            imageName: "sunrise.fill",
                            title: "Sunrise",
                            value: viewModel.sunrise
                        )
                        
                        InfoCardView(
                            imageName: "sunset.fill",
                            title: "Sunset",
                            value: viewModel.sunset
                        )
                    }
                    .padding()
                    .background(BlurView(style: .systemUltraThinMaterial))
                    .cornerRadius(15)
                    .shadow(radius: 10)
                }
            }
            .padding(.horizontal, 7)
        }
        .onAppear {
            viewModel.fetchSunriseSunset()  // City name already managed in the ViewModel
        }
    }
}

// Reusable Info Card View
struct InfoCardView: View {
    let imageName: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .font(.title2)
                .foregroundStyle(Color.yellow)
            Text("\(title):")
                .font(.body)
                .foregroundColor(.white)
                .fontWeight(.bold)
            Spacer()
            Text(value)
                .font(.body)
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
    }
}


#Preview {
    SunriseSunsetView()
}
