//
//  FetchMovie.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 15..
//

struct FetchMoviesRequest: LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    let genreId: Int
    let includeAdult: Bool
    let page: Int
    
    func asRequestParams() -> [String: Any] {
        return [
            "with_genres": genreId,
            "include_adult": includeAdult,
            "page": page,
        ] + languageParam
    }
}
