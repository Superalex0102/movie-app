//
//  FetchMovie.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 15..
//

struct FetchMoviesRequest {
    let accessToken: String = Config.bearerToken
    let genreId: Int
    
    func asRequestParams() -> [String: Any] {
        return ["with_genres": genreId]
    }
}
