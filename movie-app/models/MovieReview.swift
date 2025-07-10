//
//  MovieReview.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 07. 10..
//

import Foundation

struct MovieReview: Identifiable {
    let id: String
    let author: String
    let content: String
    let rating: Int?
    let avatarURL: URL?

    init(id: String, author: String, content: String, rating: Int?, avatarURL: URL?) {
        self.id = id
        self.author = author
        self.content = content
        self.rating = rating
        self.avatarURL = avatarURL
    }

    init(dto: MovieReviewResponse) {
        self.id = dto.id
        self.author = dto.author
        self.content = dto.content
        self.rating = dto.authorDetails.rating
        self.avatarURL = dto.authorDetails.avatarPath.flatMap { path in
            if path.hasPrefix("/") {
                return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
            } else {
                return URL(string: path)
            }
        }
    }
}
