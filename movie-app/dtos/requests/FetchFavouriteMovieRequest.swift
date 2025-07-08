//
//  FavouriteMovieRequest.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 05..
//

struct FetchFavouriteMovieRequest: LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    let accountId: Int = Config.accountID
    
    func asRequestParams() -> [String: Any] {
        return languageParam
    }
}
