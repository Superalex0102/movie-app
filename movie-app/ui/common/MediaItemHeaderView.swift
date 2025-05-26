//
//  MediaItemHeader.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 26..
//

import SwiftUI

struct MediaItemHeaderView: View {
    
    let title: String
    let year: String
    let runtime: String
    let spokenLanguages: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConst.largePadding) {
            Text(title)
                .font(Fonts.detailsTitle)
            
            HStack(spacing: LayoutConst.normalPadding) {
                DetailLabel(title: "detail.releaseDate", description: year)
                DetailLabel(title: "detail.runtime", description: "\(runtime)")
                DetailLabel(title: "detail.language", description: spokenLanguages)
            }
        }
    }
}
