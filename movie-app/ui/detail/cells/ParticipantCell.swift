//
//  ParticiantCell.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 20..
//

import SwiftUI

struct ParticipantCell: View {
    let imageUrl: URL?
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            
            LoadImageView(url: imageUrl)
                .frame(width: 56, height: 56)
                .cornerRadius(28)
            
            Text(title)
                .font(Fonts.subheading)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: 100.0)
    }
}
