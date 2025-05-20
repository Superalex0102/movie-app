//
//  MovieCreditResponse.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 20..
//

import Foundation

struct MovieCreditsResponse: Codable {
    let id: Int
    let cast: [CastMemberResponse]
    
    enum CodingKeys: String, CodingKey {
        case id
        case cast
    }
}
