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
                        .frame(width: 24, height: 24)
                    
                    TextField("",
                              text: $viewModel.searchText,
                              prompt: Text("search.textfield.placeholder".localized())
                                            .foregroundStyle(.invertedMain)
                    )
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(Fonts.caption)
                        .foregroundColor(.invertedMain)
                        .onChange(of: viewModel.searchText) {
                            viewModel.startSearch.send(())
                        }
                }
                .frame(height: 56)
                .padding(.horizontal, LayoutConst.normalPadding)
                .background(Color.searchBarForeground)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.invertedMain, lineWidth: 1)
                )
                .cornerRadius(28)
                .padding(.horizontal, LayoutConst.maxPadding)
                
                if viewModel.movies.isEmpty {
                    // Üres állapot
                    VStack {
                        Spacer()
                        Text("search.empty.title".localized())
                            .multilineTextAlignment(.center)
                            .font(Fonts.emptyStateText)
                            .foregroundColor(.invertedMain)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: LayoutConst.normalPadding) {
                            ForEach(viewModel.movies) { movie in
                                NavigationLink(destination: DetailView(mediaItem: movie)) {
                                    MovieCell(movie: movie, width: 373.0, height: 180.0)
                                        .frame(height: 277)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, LayoutConst.normalPadding)
                        .padding(.top, LayoutConst.normalPadding)
                    }
                }
            }
        }
        .onAppear {
            viewModel.startSearch.send(())
        }
    }
}

#Preview {
    SearchView()
        .preferredColorScheme(.dark) // Hogy jobban látszódjon a fehér szöveg
}
