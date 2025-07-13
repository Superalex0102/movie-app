//
//  MediaItemReviewStore.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 07. 13..
//

import RealmSwift
import Combine

protocol MovieReviewStoreProtocol {
    func getMovieReviews(fromMovieId movieId: Int) -> AnyPublisher<[MovieReview], MovieError>
    func saveMovieReviews(_ items: [MovieReview], forMovieId movieId: Int)
    func deleteMovieReviews(fromMovieId movieId: Int)
    func deleteAll()
}

class MovieReviewStore: MovieReviewStoreProtocol {
    private let realm: Realm

    init() {
        guard let realm = try? Realm() else {
            fatalError("Failed to initialize Realm")
        }
        self.realm = realm
    }

    func getMovieReviews(fromMovieId movieId: Int) -> AnyPublisher<[MovieReview], MovieError>{
        let results = realm.objects(MediaItemReviewEntity.self)
            .where {
                $0.movieId == movieId
            }
        let mediaItemReview = results.map { $0.toDomain }
        return Just(Array(mediaItemReview))
            .setFailureType(to: MovieError.self)
            .eraseToAnyPublisher()
    }

    func saveMovieReviews(_ items: [MovieReview], forMovieId movieId: Int) {
        let entities = items.map { review in
            let entity = MediaItemReviewEntity(from: review, movieId: movieId)
            return entity
        }
        try? realm.write {
            realm.add(entities, update: .modified)
        }
    }

    func deleteMovieReviews(fromMovieId movieId: Int) {
        let items = realm.objects(MediaItemReviewEntity.self)
            .where {
                $0.movieId == movieId
            }
        try? realm.write {
            realm.delete(items)
        }
    }

    func deleteAll() {
        let all = realm.objects(MediaItemReviewEntity.self)
        try? realm.write {
            realm.delete(all)
        }
    }
}
