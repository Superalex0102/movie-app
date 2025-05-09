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
            GeometryReader { geometry in
                Image(.ellipse)
                    .resizable()
                    .frame(width: 449, height: 449)
                    .position(x: geometry.size.width - 205, y: 225)
            }
            
            NavigationView {
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
            .alert(item: $viewModel.alertModel) { model in
                return Alert(
                    title: Text(model.title),
                    message: Text(model.message),
                    dismissButton: .default(Text(model.dismissButtonTitle)) {
                        viewModel.alertModel = nil
                    }
                )
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GenreSectionView()
}
