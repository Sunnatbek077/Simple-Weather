//
//  LanguageSelectionView.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 23/01/25.
//

import SwiftUI

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}

struct LanguageSelectionView: View {
    @State private var selectedLanguage: Language? = nil
    @State private var systemLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    @State private var showAlert = false  // Alertni ko'rsatish uchun o'zgaruvchi
    
    let languages = [
        Language(name: "English", code: "en", flag: "🇬🇧"),
        Language(name: "Русский", code: "ru", flag: "🇷🇺"),
        Language(name: "O‘zbek", code: "uz", flag: "🇺🇿"),
        Language(name: "Deutsch", code: "de", flag: "🇩🇪"),
        Language(name: "العربية", code: "ar", flag: "🇸🇦"),
        Language(name: "Türkçe", code: "tr", flag: "🇹🇷")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
               // List of languages to choose from
                List(languages) { language in
                    HStack {
                        Text(language.flag)
                        Text(language.name)
                            .font(.headline)
                        Spacer()
                        if selectedLanguage?.code == language.code {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .onTapGesture {
                        selectedLanguage = language
                    }
                }
                
                // Confirm button
                Button(action: {
                    if let language = selectedLanguage {
                        changeLanguage(to: language)
                    }
                }) {
                    Text(NSLocalizedString("Confirm", comment: ""))
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .disabled(selectedLanguage == nil)
            }
            .navigationTitle(NSLocalizedString("Select Language", comment: ""))
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Restart Required"),
                    message: Text("The application must be restarted for the changes to take effect."),
                    primaryButton: .default(Text("OK")) {
                        // Dasturni to'liq yopish
                        exit(0)
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    private func localizedLanguageName(for code: String) -> String {
        let locale = Locale(identifier: code)
        return locale.localizedString(forLanguageCode: code) ?? "Unknown"
    }
    
    private func changeLanguage(to language: Language) {
        // Change the language of the app dynamically
        _ = Locale(identifier: language.code)
        UserDefaults.standard.set([language.code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Post the custom notification to reload the UI
        NotificationCenter.default.post(name: .languageChanged, object: nil)
        
        print("Language changed to: \(language.name)")
        
        // Xabarnoma ko'rsatish
        showAlert = true
    }
}

#Preview {
    LanguageSelectionView()
}
