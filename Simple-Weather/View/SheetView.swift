//
//  SheetView.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 19/01/25.
//

import SwiftUI

struct SheetView: View {
    @StateObject private var viewModel = CityViewModel()
    @State private var searchText2 = ""
    @AppStorage("isSheetPresented") private var isSheetPresented:Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button{
                    isSheetPresented.toggle()
                    viewModel.saveSelectedCity()
                }label: {
                    Text("Done")
                        .padding()
                        .bold()
                        .font(.body)
                }
            }
            TextField("Enter City name", text: $searchText2)
                .onSubmit {
                    viewModel.fetchCities(query: searchText2)
                }
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            List(viewModel.cities, id: \.id) { city in
                VStack(alignment: .leading) {
                    Text(city.name)
                        .font(.headline)
                    Text("\(city.region), \(city.country)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    viewModel.selectedCity = city // Update selected city when tapped
                    print("Selected city: \(city.name)")
                }
            }
            
            if viewModel.cities.isEmpty {
                Text("No cities found. Please try again.")
                    .foregroundColor(.red)
                    .padding()
            }
            
            if let selectedCity = viewModel.selectedCity {
                Text("Selected City: \(selectedCity.name), \(selectedCity.region), \(selectedCity.country)")
                    .padding()
                    .font(.title2)
                    .foregroundColor(.green)
            } else {
                Text("No city selected")
                    .padding()
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            
            
        }
        .onAppear {
            viewModel.loadSelectedCity() // Load the selected city when the view appears
        }
        
    }
}



#Preview {
    SheetView()
}
