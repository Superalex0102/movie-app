//
//  CastMemberStore.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 26..
//

import RealmSwift
import Combine

protocol CastMemberStoreProtocol {
    func getCastMembers(fromMovieId movieId: Int) -> AnyPublisher<[CastMember], MovieError>
    func saveCastMembers(_ items: [CastMember], forMovieId movieId: Int)
    func deleteCastMembers(fromMovieId movieId: Int)
    func deleteAll()
}

class CastMemberStore: CastMemberStoreProtocol {
    private let realm: Realm

    init() {
        guard let realm = try? Realm() else {
            fatalError("Failed to initialize Realm")
        }
        self.realm = realm
    }

    func getCastMembers(fromMovieId movieId: Int) -> AnyPublisher<[CastMember], MovieError> {
        let results = realm.objects(CastMemberEntity.self)
            .where {
                $0.movieId == movieId
            }
        let castMembers = results.map { $0.toDomain }
        return Just(Array(castMembers))
            .setFailureType(to: MovieError.self)
            .eraseToAnyPublisher()
    }

    func saveCastMembers(_ items: [CastMember], forMovieId movieId: Int) {
        let entities = items.map { cast in
            let entity = CastMemberEntity(from: cast, movieId: movieId)
            return entity
        }
        try? realm.write {
            realm.add(entities, update: .modified)
        }
    }

    func deleteCastMembers(fromMovieId movieId: Int) {
        let items = realm.objects(CastMemberEntity.self)
            .where {
                $0.movieId == movieId
            }
        try? realm.write {
            realm.delete(items)
        }
    }

    func deleteAll() {
        let all = realm.objects(CastMemberEntity.self)
        try? realm.write {
            realm.delete(all)
        }
    }
}
