//
//  SettingsViewModel.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 26..
//

import Foundation
import SwiftUI

protocol SettingsViewModelProtocol: ObservableObject {
    
}

class SettingsViewModel: SettingsViewModelProtocol, ErrorPresentable {
    @Published var alertModel: AlertModel? = nil
    @Published var selectedLanguage: String = Bundle.getLangCode()
    @Published var selectedTheme: ColorScheme = .light
    
    @AppStorage("color-scheme") var colorSchemeRawValue: String = "light"
    
    init() {
        let currentSystemScheme = UITraitCollection.current.userInterfaceStyle
        self.selectedTheme = ColorScheme(colorSchemeRawValue)
    }
    
    func changeSelectedLanguage(_ language: String) {
        self.selectedLanguage = language
        Bundle.setLanguage(lang: language)
    }
    
    func changeTheme(_ theme: ColorScheme) {
        self.selectedTheme = theme
        colorSchemeRawValue = theme == .light ? "light" : "dark"
    }
    
    //let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
}

extension ColorScheme {
    var rawValue: String {
        self == .light ? "light" : "dark"
    }
    
    init(_ rawValue: String) {
        self = rawValue == "light" ? .light : .dark
    }
}
