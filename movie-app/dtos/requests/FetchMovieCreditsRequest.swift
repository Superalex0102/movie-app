//
//  FetchMovieCreditsRequest.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 20..
//

struct FetchMovieCreditsRequest: LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    
    func asRequestParams() -> [String: Any]{
        return languageParam
    }
}
