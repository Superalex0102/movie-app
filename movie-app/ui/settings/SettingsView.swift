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
        ZStack(alignment: .topTrailing) {
            NavigationView {
                ZStack {
                    GeometryReader { geometry in
                        Image(.ellipse)
                            .resizable()
                            .frame(width: 400, height: 400)
                            .position(x: geometry.size.width - 50, y: 50)
                            .padding()
                    }
                    .ignoresSafeArea()
                    .background(Color.clear)
                    .listStyle(.plain)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 30.0) {
                            Text("settings.chooseLanguage")
                                .font(Fonts.overviewText)
                            HStack(spacing: 6.0) {
                                StyledButton(style: .outlined, action: .simple, title: "settings.language.english")
                                StyledButton(style: .outlined, action: .simple, title: "settings.language.german")
                                StyledButton(style: .filled, action: .simple, title: "settings.language.hungarian")
                            }
                            
                            Text("settings.chooseTheme")
                                .font(Fonts.overviewText)
                            HStack(spacing: 12.0) {
                                StyledButton(style: .outlined, action: .simple, title: "settings.lightmode")
                                    .frame(maxWidth: .infinity)
                                StyledButton(style: .filled, action: .simple, title: "settings.darkmode")
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        Spacer(minLength: 250)
                        
                        VStack(alignment: .leading, spacing: 12.0) {
                            Text("version: place version here")
                                .font(Fonts.overviewText)
                            Text("Created by place name here")
                                .font(Fonts.overviewText)
                        }
                    }
                    .padding(LayoutConst.maxPadding)
                }
                .accessibilityLabel("testCollectionView")
                .navigationTitle("settings.title")
            }
            .showAlert(model: $viewModel.alertModel)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SettingsView()
} 
