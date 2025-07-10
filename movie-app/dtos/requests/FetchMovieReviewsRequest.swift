//
//  FetchMovieReviewsRequest.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 07. 10..
//

struct FetchMovieReviewsRequest: LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    let page: Int
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
