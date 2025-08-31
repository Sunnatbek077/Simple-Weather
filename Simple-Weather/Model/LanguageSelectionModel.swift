//
//  Language Selection Model.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 23/01/25.
//

import Foundation

struct Language: Identifiable {
    let id = UUID()
    let name: String
    let code: String
    let flag: String // Emoji yoki tasvir
}

let languages = [
    Language(name: "English", code: "en", flag: "🇬🇧"),
    Language(name: "Русский", code: "ru", flag: "🇷🇺"),
    Language(name: "O‘zbek", code: "uz", flag: "🇺🇿"),
    Language(name: "Deutsch", code: "de", flag: "🇩🇪"),
    Language(name: "العربية", code: "ar", flag: "🇸🇦"),
    Language(name: "Türkçe", code: "tr", flag: "🇹🇷")
]
