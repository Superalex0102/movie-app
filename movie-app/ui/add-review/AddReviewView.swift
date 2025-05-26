//
//  AddReviewView.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 24..
//

import SwiftUI

struct AddReviewView: View {
    
    let mediaItemDetail: MediaItemDetail
    
    @StateObject private var viewModel = AddReviewViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LayoutConst.normalPadding) {
                MediaItemHeaderView(title: viewModel.mediaItemDetail.title,
                                    year: viewModel.mediaItemDetail.year,
                                    runtime: "\(viewModel.mediaItemDetail.runtime)",
                                    spokenLanguages: viewModel.mediaItemDetail.spokenLanguages)
                LoadImageView(url: mediaItemDetail.imageUrl)
                    .frame(height: 185)
                    .cornerRadius(30)
                Text(LocalizedStringKey("addReview.subTitle"))
                    .font(Fonts.detailsTitle)
                HStack {
                    Spacer()
                    VStack (spacing: 72.0){
                        StarRatingView(rating: $viewModel.selectedRating)
                        StyledButton(style: .filled, action: .simple, title: "addReview.buttonTitle")
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, LayoutConst.maxPadding)
        .onAppear {
            viewModel.mediaDetailSubject.send(mediaItemDetail)
        }
    }
}
