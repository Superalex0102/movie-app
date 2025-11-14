//
//  MovieCell.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 26..
//

import SwiftUI

struct MovieCell: View {
    let movie: Movie
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConst.smallPadding) {
            ZStack(alignment: .topLeading) {
                HStack(alignment: .center) {
                    LoadImageView(url: movie.imageUrl)
                        .frame(width: width, height: height)
                        .cornerRadius(30)
                }
                HStack {
                    MovieLabel(type: .rating(movie.rating))
                    MovieLabel(type: .voteCount(movie.voteCount))
                }
                .padding(LayoutConst.smallPadding)
            }

            HStack {
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(Fonts.subheading)
                        .lineLimit(2)
                    
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
