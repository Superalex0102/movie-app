//
//  SearchMovieRequest.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 26..
//

struct SearchMovieRequest {
    let accessToken: String = Config.bearerToken
    let query: String
    
    func asRequestParams() -> [String: Any] {
        return [
            "query": query
        ]
    }
} 
