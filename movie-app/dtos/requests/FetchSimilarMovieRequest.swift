//
//  SimilarMovieRequest.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 06. 24..
//

struct FetchSimilarMovieRequest: LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    let mediaItemId: Int
    let page: Int
    
    func asRequestParams() -> [String: Any] {
        return [
            "movie_id": mediaItemId,
            "page": page,
        ] + languageParam
    }
}
