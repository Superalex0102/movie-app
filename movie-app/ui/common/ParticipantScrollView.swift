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
        case castMember
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
                            case .castMember:
                                NavigationLink(destination: CastMemberDetailView(castDetailType: .castMember(id: participant.id))) {
                                    ParticipantCell(imageUrl: participant.imageUrl, title: participant.name)
                                }
                                .buttonStyle(PlainButtonStyle())
                            case .company:
                                NavigationLink(destination: CastMemberDetailView(castDetailType: .company(id: participant.id))) {
                                    ParticipantCell(imageUrl: participant.imageUrl, title: participant.name)
                                }
                                .buttonStyle(PlainButtonStyle())
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
