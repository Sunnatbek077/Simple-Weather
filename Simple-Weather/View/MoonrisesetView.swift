//
//  MoonrisemoonsetView.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 15/01/25.
//

import SwiftUI

struct MoonrisesetView: View {
    @StateObject private var viewModel = MoonrisesetViewModel()

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                
                HStack {
                    Image(systemName: "moonrise.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Moonrise: ")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(viewModel.moonriseTime)")
                        .font(.body)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }

                HStack {
                    Image(systemName: "moonset.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Moonset: ")
                        .font(.headline)
                        .foregroundColor(.white)

                    Spacer()
                    
                    Text("\(viewModel.moonsetTime)")
                        .font(.body)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                
                HStack {
                    Image(systemName: "moonphase.full.moon")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("Moon lighting:")
                        .font(.body)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    if let illumination = viewModel.moonIllumination {
                        Text("\(illumination)%")
                            .font(.body)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    } else {
                        Text("Moon Illumination: N/A")
                            .font(.body)
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                    }
                    
                }
                
            }
            .padding()
            .background(BlurView(style: .systemUltraThinMaterial))
            .cornerRadius(15)
            .shadow(radius: 10)
            Spacer()
        }
        .onAppear {
            // Ekran ochilganda API'ni chaqirish
            viewModel.fetchMoonrisesetData()
        }
        .padding(.horizontal, 7)
    }
}

#Preview {
    MoonrisesetView()
}
