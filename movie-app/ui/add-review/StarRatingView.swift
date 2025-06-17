//
//  StarRatingView.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 24..
//

import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int
    var starSize: CGFloat = 40.0
    var onTap: ((Int) -> Void)?
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<5, id: \.self) { index in
                StarView(index: index,
                         isFilled: index <= rating,
                         size: starSize,
                         onTap: {
                    onTap?(index)
                })
            }
        }
    }
}
