//
//  ContentView.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 08..
//

import SwiftUI
import InjectPropertyWrapper
import Shimmer

struct GenreSectionView: View {
    
    @StateObject private var viewModel = GenreSectionViewModelImpl()
    
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
                    
                    List {
                        if let motd = viewModel.motdMovie {
                            GenreMotdCell(mediaItem: motd)
                            .background(Color.clear)
                            .listStyle(.plain)
                        }
                        
                        ForEach(viewModel.genres) { genre in
                            ZStack {
                                NavigationLink(destination: MovieListView(genre: genre)) {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                GenreSectionCell(genre: genre, movies: viewModel.getMovies(genre: genre))
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                    }
                    .background(Color.clear)
                    .listStyle(.plain)
                    .navigationTitle(Environments.name == .tv ? "TV" : "genreSection.title".localized())
                    .accessibilityLabel("testCollectionView")
                }
            }
            .showAlert(model: $viewModel.alertModel)
            .onAppear {
                viewModel.loadGenres()
                viewModel.genresAppeared()
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GenreSectionView()
}
