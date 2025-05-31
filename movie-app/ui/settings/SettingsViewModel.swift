//
//  SettingsViewModel.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 26..
//

import Foundation

protocol SettingsViewModelProtocol: ObservableObject {
    
}

class SettingsViewModel: SettingsViewModelProtocol, ErrorPresentable {
    @Published var alertModel: AlertModel? = nil
    @Published var selectedLanguage: String = Bundle.getLangCode()
    
    private let themeKey = "color-scheme"
    
    @Published var selectedTheme: Theme {
        didSet {
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: themeKey)
        }
    }
    
    init() {
        let storedTheme = UserDefaults.standard.string(forKey: themeKey)
        self.selectedTheme = Theme(rawValue: storedTheme ?? "") ?? .light
    }
    
    func changeSelectedLanguage(_ language: String) {
        self.selectedLanguage = language
        Bundle.setLanguage(lang: language)
    }
    
    func changeTheme(_ theme: Theme) {
        self.selectedTheme = theme
    }
}
