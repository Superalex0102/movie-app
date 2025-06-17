//
//  CastMemberDetailView.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 06. 14..
//

import SwiftUI

struct CastDetailView: View {
    @StateObject private var viewModel = CastDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    
    let castDetailType: CastDetailType
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView {
                    if let cast = viewModel.castDetail {
                        VStack(alignment: .leading, spacing: 24) {
                            HStack {
                                Spacer()
                                LoadImageView(url: cast.imagePath)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 370, height: 185)
                                    .cornerRadius(20)
                                Spacer()
                            }
                            
                            Text(cast.name)
                                .font(Fonts.detailsTitle)
                                .foregroundColor(Color.primary)
                                .padding(.horizontal)
                            
                            HStack(spacing: 40) {
                                VStack(alignment: .leading) {
                                    Text("Birth year")
                                        .font(Fonts.caption)
                                        .foregroundColor(Color.primary)
                                    Text(cast.birthYear ?? "N/A")
                                        .font(Fonts.paragraph)
                                        .foregroundColor(Color.primary)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("City")
                                        .font(Fonts.caption)
                                        .foregroundColor(Color.primary)
                                    Text(cast.originPlace ?? "N/A")
                                        .font(Fonts.paragraph)
                                        .foregroundColor(Color.primary)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Bio")
                                    .font(Fonts.caption)
                                    .foregroundColor(Color.primary)
                                Text(cast.biography ?? "N/A")
                                    .font(Fonts.paragraph)
                                    .foregroundColor(Color.primary)
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Popularity")
                                    .font(Fonts.caption)
                                    .foregroundColor(Color.primary)
                                HStack {
                                    Spacer()
                                    StarRatingView(rating: $viewModel.rating, starSize: 24)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                            
                        }
                        .padding(.vertical, 48)
                    } else {
                        ProgressView()
                    }
                }
            }
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.participantTypeSubject.send(castDetailType)
        }
    }
}
