//
//  StarView.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 24..
//

import SwiftUI

struct StarView: View {
    let index: Int
    let isFilled: Bool
    var size: CGFloat = 40.0
    let onTap: (() -> Void)?

    var body: some View {
        Image(isFilled ? .starFilled : .starUnfilled)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40.0, height: 40.0)
            .onTapGesture {
                onTap?()
            }
    }
}
