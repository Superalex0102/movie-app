//
//  StyledButton.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 10..
//

import SwiftUI

enum ButtonStyleType {
    case filled
    case outlined
}

struct StyledButton: View {
    let style: ButtonStyleType
    let title: String
    let action: () -> Void = {}
    
    var body: some View {
        Button(action: action) {
            Text(LocalizedStringKey(title))
                .font(Fonts.subheading)
                .foregroundColor(style == .outlined ? .primary : .main)
                .padding(.horizontal, 32.0)
                .padding(.vertical, LayoutConst.normalPadding)
                .background(backgroundView)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.primary, lineWidth: style == .outlined ? 1 : 0)
                )
        }
    }
    
    private var backgroundView: some View {
        switch style {
        case .filled:
            Color.primary
        case .outlined:
            Color.main
        }
    }
}
