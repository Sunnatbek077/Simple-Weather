//
//  ProfileView.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 22/01/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var newPassword: String = ""
    @State private var saveMessage: String? = nil  // Saqlash xabarini ko'rsatish uchun
    
    var body: some View {
        VStack {
            // Xabarni yuqori qismda ko'rsatish
            if let message = saveMessage {
                Text(message)
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding()
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.top, 10)
                    .transition(.slide)
                    .animation(.easeInOut, value: saveMessage)
            }
            
            Form {
                Section(header: Text("Profile Info")) {
                    TextField("Name", text: $viewModel.name)
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true) // Avtomatik xatolarni to'g'irlashni o'chiradi
                    
                    SecureField("Password", text: $newPassword)
                    
                    Button(action: {
                        viewModel.updatePassword(newPassword: newPassword)
                    }) {
                        Text("Update Password")
                    }
                }
                
                Section {
                    Button(action: {
                        viewModel.saveProfile()
                        saveMessage = "Profile saved successfully!"
                        
                        // Xabarni bir necha soniya davomida ko'rsatish
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            saveMessage = nil
                        }
                    }) {
                        Text("Save Profile")
                            .foregroundColor(.blue)
                    }
                    
                    // Profilni o'chirish uchun tugma
                    Button(action: {
                        viewModel.deleteProfile()
                        saveMessage = "Profile deleted successfully!"
                        
                        // Xabarni bir necha soniya davomida ko'rsatish
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            saveMessage = nil
                        }
                    }) {
                        Text("Delete Profile")
                            .foregroundColor(.red)
                    }
                }
            }
            
            .onAppear {
                // Profile ni yuklash
                viewModel.loadProfile()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: "person.fill")
                    Text("Profile")
                        .font(.headline)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProfileView()
}
