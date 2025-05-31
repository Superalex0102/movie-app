//
//  MovieCell.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 26..
//

import SwiftUI

struct MovieCellView: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConst.smallPadding) {
            ZStack(alignment: .topLeading) {
                HStack(alignment: .center) {
                    LoadImageView(url: movie.imageUrl)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                }
                //TODO: spacing between the two HStack is not correct
                HStack {
                    HStack(spacing: 6) {
                        Image(.star)
                        Text(String(format: "%.1f", movie.rating))
                            .font(Fonts.labelBold)
                    }
                    .padding(6)
                    .background(Color.main.opacity(0.5))
                    .cornerRadius(12)
                    .padding(4)
                    
                    //TODO: better format for voteCount
                    HStack(spacing: 6) {
                        Image(.heart)
                        Text(String(movie.voteCount))
                            .font(Fonts.labelBold)
                    }
                    .padding(6)
                    .background(Color.main.opacity(0.5))
                    .cornerRadius(12)
                    .padding(4)
                }
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
