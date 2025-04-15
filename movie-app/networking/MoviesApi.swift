//
//  MoviesApi.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 12..
//

import Foundation
import Moya

enum MoviesApi {
    case fetchGenres(req: FetchGenreRequest)
    case fetchTVGenres(req: FetchGenreRequest)
    case fetchMovies(req: FetchMoviesRequest)
}

extension MoviesApi : TargetType {
    var baseURL: URL {
        let baseUrl = "https://api.themoviedb.org/3/"
        guard let baseUrl = URL(string: baseUrl) else {
            preconditionFailure("Base url not valid url")
        }
        return baseUrl
    }
    
    var path: String {
        switch self {
        case .fetchGenres:
            return "genre/movie/list"
        case .fetchTVGenres:
            return "genre/tv/list"
        case .fetchMovies:
            return "discover/movie"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchGenres, .fetchTVGenres, .fetchMovies:
            return .get
        }
    }
    
    //TODO: Másik Encoding
    var task: Moya.Task {
        switch self {
        case let .fetchGenres(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchTVGenres(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .fetchTVGenres(req):
            return ["Authorization": req.accessToken]
        case let .fetchGenres(req):
            return ["Authorization": req.accessToken]
        case let .fetchMovies(req):
            return ["Authorization": req.accessToken]
        }
    }
}
