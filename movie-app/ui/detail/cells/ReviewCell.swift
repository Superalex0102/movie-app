//
//  ReviewCell.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 07. 10..
//

import SwiftUI

struct ReviewCell: View {
    let review: MovieReview
    
    var body: some View {
        VStack(alignment: .leading) {
            
            //Design issue, after too long names, review doesn't have enough space to show
            HStack(spacing: LayoutConst.smallPadding) {
                Text(review.author)
                    .font(Fonts.subheading)
                Spacer()
                if let rating = review.rating {
                    MovieLabel(type: .rating(Double(rating)))
                }
            }
            
            Text(review.content)
                .font(Fonts.paragraphList)
                .lineLimit(3)
        }
        .frame(maxWidth: 136.0)
    }
}
