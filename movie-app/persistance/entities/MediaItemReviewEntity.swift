//
//  MediaItemReviewEntity.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 07. 13..
//

import Foundation
import RealmSwift

class MediaItemReviewEntity: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var author: String
    @Persisted var content: String
    @Persisted var rating: Int?
    @Persisted var avatarURL: String?
    @Persisted var movieId: Int
}

extension MediaItemReviewEntity {
    convenience init(from model: MovieReview, movieId: Int) {
        self.init()
        self.id = model.id
        self.author = model.author
        self.content = model.content
        self.rating = model.rating
        self.avatarURL = model.avatarURL?.absoluteString
        self.movieId = movieId
    }

    var toDomain: MovieReview {
        return MovieReview(
            id: id,
            author: author,
            content: content,
            rating: rating,
            avatarURL: avatarURL.flatMap(URL.init(string:)),
        )
    }
}
