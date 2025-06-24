//
//  SimilarScrollView.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 06. 24..
//

import SwiftUI

struct SimilarMovieView: View {
    let title: String
    var movies: [Movie]
    
    @State var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title.localized())
                .font(Fonts.title)
                .foregroundStyle(.primary)
            
            ScrollView(.horizontal, showsIndicators: false) {
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
