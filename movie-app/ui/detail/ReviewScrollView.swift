//
//  ReviewScrollView.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 07. 10..
//

import SwiftUI

struct ReviewScrollView: View {
    var reviews: [MovieReview]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("detail.reviews".localized())
                .font(Fonts.overviewText)
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                LazyHStack(spacing: 90.0) {
                    ForEach(self.reviews) { review in
                        ReviewCell(review: review)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
