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
                    AsyncImage(url: movie.imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                Color.gray.opacity(0.3)
                                ProgressView()
                            }

                        case let .success(image):
                            image
                                .resizable()
                                .scaledToFill()

                        case .failure(let error):
                            ZStack {
                                Color.red.opacity(0.3)
                                Image(systemName: "photo")
                                    .foregroundColor(.white)
                            }
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                }
                
                //TODO: Import star image and add new font
                HStack(spacing: 6) {
                    Image(.star)
                    Text(String(format: "%.1f", movie.rating))
                        .font(Fonts.labelBold)
                }
                .padding(6)
                .background(Color.main.opacity(0.5))
                .cornerRadius(12)
                .padding(6)
            }

            Text(movie.title)
                .font(Fonts.subheading)
                .lineLimit(2)

            Text("\(movie.year)")
                .font(Fonts.paragraph)

            Text("\(movie.duration)")
                .font(Fonts.caption)

            Spacer()
        }
    }
}
