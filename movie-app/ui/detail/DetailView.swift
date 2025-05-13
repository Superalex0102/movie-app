//
//  DetailView.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 10..
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel = DetailViewModel()
    let mediaItem: Movie
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LayoutConst.largePadding) {
                AsyncImage(url: mediaItem.imageUrl) { phase in
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
                .frame(maxHeight: 180)
                .frame(maxWidth: .infinity)
                .cornerRadius(30)
                
                HStack(spacing: 12.0) {
                    MovieLabel(type: .rating(viewModel.mediaItemDetail.rating))
                    MovieLabel(type: .voteCount(viewModel.mediaItemDetail.voteCount))
                    MovieLabel(type: .popularity(viewModel.mediaItemDetail.popularity))
                    Spacer()
                    MovieLabel(type: .adult(viewModel.mediaItemDetail.adult))
                 }
                
                Text(viewModel.mediaItemDetail.genreList)
                    .font(Fonts.paragraph)
                Text(viewModel.mediaItemDetail.title)
                    .font(Fonts.detailsTitle)
                
                HStack(spacing: LayoutConst.normalPadding) {
                    DetailLabel(title: "detail.releaseDate", description: viewModel.mediaItemDetail.year)
                    DetailLabel(title: "detail.runtime", description: "\(viewModel.mediaItemDetail.runtime)")
                    DetailLabel(title: "detail.language", description: viewModel.mediaItemDetail.spokenLanguages)
                }
                
                HStack(spacing: LayoutConst.largePadding) {
                    StyledButton(style: .outlined, title: "detail.rate.button")
                    Spacer()
                    StyledButton(style: .filled, title: "detail.imdb.button")
                }
                
                VStack(alignment: .leading, spacing: 12.0) {
                    Text(LocalizedStringKey("detail.overview"))
                        .font(Fonts.overviewText)
                    
                    Text(viewModel.mediaItemDetail.overview)
                        .font(Fonts.paragraph)
                        .lineLimit(nil)
                }
            }
            .padding(.horizontal, LayoutConst.maxPadding)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    
                }) {
                    Image(.favourite)
                        .resizable()
                        .frame(height: 20.0)
                        .frame(width: 20.0)
                }
            }
        }
        .onAppear {
            viewModel.mediaItemIdSubject.send(mediaItem.id)
        }
    }
}
