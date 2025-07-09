//
//  FetchTrendingMoviesRequest.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 07. 08..
//

struct FetchTrendingMovieRequest: LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    let timeWindow: String
    let page: Int
    
    func asRequestParams() -> [String: Any] {
        return [
            "time_window": timeWindow,
            "page": page,
        ] + languageParam
    }
}
