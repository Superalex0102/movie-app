//
//  GenreSectionCell.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 26..
//

import SwiftUI
import Shimmer

struct GenreSectionCell: View {
    var genre: Genre
    var movies: [Movie]
    
    @State var isExpanded: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text(genre.name)
                    .font(Fonts.title)
                    .foregroundStyle(.primary)
                    .accessibilityLabel(genre.name)
                Spacer()
                RotatingArrow(isExpanded: self.isExpanded)
                    .onTapGesture {
                        isExpanded.toggle()
                    }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                //TODO: the id should be different with shimmering
                LazyHStack(spacing: 20.0) {
                    ForEach(self.movies) { movie in
                        NavigationLink(destination: DetailView(mediaItem: movie)) {
                            if movie.id <= 0 {
                                Rectangle()
                                    .frame(width: 200, height: 100)
                                    .shimmering()
                            } else {
                                GenreMovieCell(movie: movie)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
