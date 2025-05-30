//
//  GenreSectionCell.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 26..
//

import SwiftUI

struct GenreSectionCell: View {
    var genre: Genre
    var movies: [Movie]
    
    var body: some View {
        VStack {
            HStack {
                Text(genre.name)
                    .font(Fonts.title)
                    .foregroundStyle(.primary)
                    .accessibilityLabel(genre.name)
                Spacer()
                Image(.rightArrow)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20.0) {
                    ForEach(self.movies) { movie in
                        NavigationLink(destination: DetailView(mediaItem: movie)) {
                            GenreMovieCell(movie: movie)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
