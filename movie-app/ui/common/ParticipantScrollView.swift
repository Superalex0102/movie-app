//
//  ParticipantScrollView.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 20..
//

import SwiftUI

protocol ParticipantItemProtocol {
    var id: Int { get }
    var imageUrl: URL? { get }
    var name: String { get }
}

struct ParticipantScrollView: View {
    
    let title: String
    let participants: [ParticipantItemProtocol]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Text(LocalizedStringKey(title))
                .font(Fonts.overviewText)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20.0) {
                    ForEach(participants, id: \.id) { company in
                        ParticipantCell(imageUrl: company.imageUrl, title: company.name)
                            .offset(CGSize(width: LayoutConst.maxPadding, height: 0))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, -LayoutConst.maxPadding)
            
        }
    }
}
