//
//  CastMember.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 20..
//


import Foundation

struct CastMember: Identifiable {
    let id: Int
    let name: String
    let castImageURL: URL?

    init(dto: CastMemberResponse) {
        self.id = dto.id
        self.name = dto.name
        self.castImageURL = dto.profilePath.flatMap { URL(string: "https://image.tmdb.org/t/p/w185\($0)") }
    }
    
    init() {
        id = 0
        name = ""
        castImageURL = nil
    }
    
    init (id: Int, name: String, castImageURL: URL? = nil) {
        self.id = id
        self.name = name
        self.castImageURL = castImageURL
    }
}

extension CastMember: ParticipantItemProtocol {
    var imageUrl: URL? {
        castImageURL
    }
}
