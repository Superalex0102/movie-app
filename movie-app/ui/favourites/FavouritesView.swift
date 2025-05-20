//
//  FavouritesView.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 26..
//

import SwiftUI
import InjectPropertyWrapper

struct FavouritesView: View {
    @StateObject private var viewModel = FavouritesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: LayoutConst.normalPadding) {
                    ForEach(viewModel.mediaItems) { movie in
                        NavigationLink(destination: DetailView(mediaItem: movie)) {
                            MovieCell(movie: movie)
                                .frame(height: 277)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, LayoutConst.normalPadding)
                .padding(.top, LayoutConst.normalPadding)
            }
            .navigationTitle("favouriteMovies.title")
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.viewLoaded.send(())
        }
    }
}

#Preview {
    FavouritesView()
}
