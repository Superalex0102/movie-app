//
//  ContentView.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 08..
//

import SwiftUI

class GenreSectionViewModel: ObservableObject {
    @Published var genres: [Genre] = []
    
    func loadGenres() {
        self.genres = [
            Genre(id: 1, name: "Adventure"),
            Genre(id: 2, name: "Sci-fi"),
            Genre(id: 3, name: "Fantasy"),
            Genre(id: 4, name: "Comedy"),
        ]
    }
}

struct GenreSectionView: View {
    
    @StateObject private var viewModel = GenreSectionViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.genres) { genre in
                ZStack {
                    NavigationLink(destination: Color.gray) {
                        EmptyView()
                    }
                    .opacity(0)
                    
                    HStack {
                        Text(genre.name)
                            .font(Fonts.title)
                            .foregroundStyle(Color.primary)
                        Spacer()
                        Image(.rightArrow)
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .background(Color.clear)
            .listStyle(.plain)
            .navigationTitle("genreSection.title")
        }
        .onAppear {
            viewModel.loadGenres()
        }
    }
}

#Preview {
    GenreSectionView()
}
