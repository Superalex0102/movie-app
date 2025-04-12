//
//  FetchGenreRequest.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 12..
//


struct FetchGenreRequest {
    let accessToken: String = "Config.bearerToken"
    
    func asRequestParams() -> [String: String] {
        return [:]
    }
}
