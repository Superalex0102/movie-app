//
//  SettingsView.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 26..
//

import SwiftUI
import InjectPropertyWrapper

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            Text("Settings Screen")
                .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
} 
