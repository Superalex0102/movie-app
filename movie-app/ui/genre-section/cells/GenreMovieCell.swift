//
//  GenreMovieCell.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 31..
//

import SwiftUI

struct GenreMovieCell: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConst.smallPadding) {
            ZStack(alignment: .topLeading) {
                HStack(alignment: .center) {
                    LoadImageView(url: movie.imageUrl)
                        .frame(width: 200, height: 100)
                        .cornerRadius(12)
                }
                HStack {
                    MovieLabel(type: .rating(movie.rating))
                    MovieLabel(type: .voteCount(movie.voteCount))
                }
            }

            HStack {
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(Fonts.subheading)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .frame(maxWidth: 150, alignment: .leading)
                    
                    Text("\(movie.year)")
                        .font(Fonts.paragraph)
                    
                    Text("\(movie.duration)")
                        .font(Fonts.caption)
                }
                
                Spacer()
                
                Image(.playButton)
            }
        }
    }
}
