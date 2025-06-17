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
    
    enum NavigationType {
        case none
        case person
        case company
    }
    
    let title: String
    let participants: [ParticipantItemProtocol]
    var navigationType: NavigationType = .none
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Text(title.localized())
                .font(Fonts.overviewText)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20.0) {
                    ForEach(participants, id: \.id) { participant in
                        Group {
                            switch navigationType {
                            case .none:
                                ParticipantCell(imageUrl: participant.imageUrl, title: participant.name)
                            case .person:
                                NavigationLink(destination: CastDetailView(castDetailType: .castMember)) {
                                    ParticipantCell(imageUrl: participant.imageUrl, title: participant.name)
                                }
                            case .company:
                                NavigationLink(destination: CastDetailView(castDetailType: .company)) {
                                    ParticipantCell(imageUrl: participant.imageUrl, title: participant.name)
                                }
                            }
                        }
                        .offset(CGSize(width: LayoutConst.maxPadding, height: 0))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, -LayoutConst.maxPadding)
            
        }
    }
}
