//
//  ContentView.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 08..
//

import SwiftUI
import InjectPropertyWrapper

struct GenreSectionView: View {
    
    @StateObject private var viewModel = GenreSectionViewModel()
    
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
                    
                    List(viewModel.genres) { genre in
                        ZStack {
                            NavigationLink(destination: MovieListView(genre: genre)) {
                                EmptyView()
                            }
                            .opacity(0)
                            
                            GenreSectionCell(genre: genre)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .background(Color.clear)
                    .listStyle(.plain)
                    .navigationTitle(Environment.name == .tv ? "TV" : "genreSection.title")
                    .accessibilityLabel("testCollectionView")
                }
            }
            .showAlert(model: $viewModel.alertModel)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GenreSectionView()
}
