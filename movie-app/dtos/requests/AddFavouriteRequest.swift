//
//  AddFavouriteRequest.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 09..
//

struct AddFavouriteRequest {
    let accessToken: String = Config.bearerToken
    let accountId: Int = 21889570
    let movieId: Int
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
