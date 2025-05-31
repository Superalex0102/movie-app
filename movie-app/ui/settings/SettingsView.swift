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
                            Text("settings.chooseLanguage".localized())
                                .font(Fonts.overviewText)
                            HStack(spacing: 6.0) {
                                StyledButton(style: viewModel.selectedLanguage == "en" ? .filled : .outlined, action: .simple, title: "settings.language.english".localized())
                                    .onTapGesture {
                                        viewModel.changeSelectedLanguage("en")
                                    }
                                StyledButton(style: viewModel.selectedLanguage == "ru" ? .filled : .outlined, action: .simple, title: "settings.language.russian".localized())
                                    .onTapGesture {
                                        viewModel.changeSelectedLanguage("ru")
                                    }
                                StyledButton(style: viewModel.selectedLanguage == "hu" ? .filled : .outlined, action: .simple, title: "settings.language.hungarian".localized())
                                    .onTapGesture {
                                        viewModel.changeSelectedLanguage("hu")
                                    }
                            }
                            
                            Text("settings.chooseTheme".localized())
                                .font(Fonts.overviewText)
                            
                            //TODO: Make the buttons strechout
                            HStack(spacing: 12.0) {
                                StyledButton(style: viewModel.selectedTheme == .light ? .filled : .outlined, action: .simple, title: "settings.lightmode".localized())
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity)
                                    .onTapGesture {
                                        viewModel.changeTheme(.light)
                                    }
                                StyledButton(style: viewModel.selectedTheme == .dark ? .filled : .outlined, action: .simple, title: "settings.darkmode".localized())
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity)
                                    .onTapGesture {
                                        viewModel.changeTheme(.dark)
                                    }
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
                .navigationTitle("settings.title".localized())
            }
            .showAlert(model: $viewModel.alertModel)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SettingsView()
} 
