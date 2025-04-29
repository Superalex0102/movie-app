//
//  SearchView.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 26..
//

import SwiftUI
import InjectPropertyWrapper

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 12) {
                    Image(.icSearch)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                    
                    TextField(LocalizedStringKey("search.textfield.placeholder"),
                            text: $viewModel.searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(Fonts.searchText)
                        .foregroundColor(.white)
                        .onChange(of: viewModel.searchText) { _ in
                            Task {
                                await viewModel.searchMovies()
                            }
                        }
                }
                .frame(height: 56)
                .padding(.horizontal, 16)
                .background(Color.searchBarForeground)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white, lineWidth: 1)
                )
                .cornerRadius(28)
                .padding(.horizontal, 30)
                
                if viewModel.movies.isEmpty {
                    // Üres állapot
                    VStack {
                        Spacer()
                        Text("search.empty.title")
                            .multilineTextAlignment(.center)
                            .font(Fonts.emptyStateText)
                            .foregroundColor(.white)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.movies) { movie in
                                MovieCellView(movie: movie)
                                    .frame(height: 277)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView()
        .preferredColorScheme(.dark) // Hogy jobban látszódjon a fehér szöveg
} 
