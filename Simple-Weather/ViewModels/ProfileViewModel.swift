//
//  ProfileViewModel.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 22/01/25.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadProfile()
    }
    
    func loadProfile() {
        name = UserDefaults.standard.string(forKey: "name") ?? ""
        email = UserDefaults.standard.string(forKey: "email") ?? ""
    }
    
    func saveProfile() {
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(email, forKey: "email")
    }
    
    func updatePassword(newPassword: String) {
        password = newPassword
    }
    
    func deleteProfile() {
        // UserDefaults-dan ma'lumotlarni o'chirish
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        
        // O'zgaruvchilarni tozalash
        name = ""
        email = ""
        password = ""
    }
}
