//
//  FavouriteMovieRequest.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 05..
//

struct FetchFavouriteMovieRequest {
    let accessToken: String = Config.bearerToken
    let accountId: Int = 21889570
    
    func asRequestParams() -> [String: String] {
        return [:]
    }
}
