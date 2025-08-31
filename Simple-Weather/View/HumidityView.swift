//
//  HumidityView.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 16/01/25.
//

import SwiftUI

struct HumidityView: View {
    
    @StateObject var viewModel = HumidityViewModel()
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "drop.fill")
                    .foregroundStyle(Color.blue)
                
                Text("Humidity:")
                    .font(.body)
                    .bold()
                    .foregroundStyle(Color.white)
            }
            .padding()
            
            Spacer()
            
            if viewModel.isLoading {
                Text("Loading Humidity data...")
                    .font(.body)
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .font(.body)
                    .bold()
                    .foregroundStyle(.red)
                    .padding()
            } else {
                Text("\(viewModel.humidity)")
                    .font(.body)
                    .bold()
                    .padding()
                    .foregroundStyle(.white)
            }
        }
        .background(BlurView(style: .systemUltraThinMaterial))
        .cornerRadius(15)
        .shadow(radius: 10)
        .onAppear {
            viewModel.fetchHumidityData()
        }
        .padding(.horizontal, 7)
    }
}

#Preview {
    HumidityView()
}
