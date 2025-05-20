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
            AsyncImage(url: imageUrl) { phase in
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
                case .failure(_):
                    ZStack {
                        Color.red.opacity(0.3)
                        Image(systemName: "photo")
                            .foregroundColor(.white)
                    }
                @unknown default:
                    EmptyView()
                }
            }
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
