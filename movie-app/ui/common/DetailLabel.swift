//
//  DetailLabel.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 10..
//

import SwiftUI

struct DetailLabel: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConst.smallPadding) {
            Text(LocalizedStringKey(title))
                .font(Fonts.caption)
            
            Text(description)
                .font(Fonts.paragraph)
        }
    }
}
