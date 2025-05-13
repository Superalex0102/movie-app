//
//  MovieLabel.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 26..
//

import SwiftUI
 
enum MovieLabelType {
    case rating(_ value: Double)
    case voteCount(_ vote: Int)
    case popularity (_ popularity: Double)
    case adult (_ adult: Bool)
}
 
struct MovieLabel: View {
     
     let type: MovieLabelType
     
     var body: some View {
         var imageRes: ImageResource
         
         var text: String
         switch type {
         case .rating(let value):
             text = String(format: "%.1f", value)
             imageRes = .star
         case .voteCount(let vote):
             text = "\(vote)"
             imageRes = .heart
         case .popularity(let popularity):
             text = "\(popularity)"
             imageRes = .person
         case .adult(let adult):
             text = adult ? "available" : "unavailable"
             imageRes = .person
         }
         
         return HStack(spacing: 6) {
             Image(imageRes)
             Text(LocalizedStringKey(text))
                 .font(Fonts.labelBold)
         }
         .padding(6.0)
         .background(Color.main.opacity(0.5))
         .cornerRadius(12)
     }
}
