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
    case fetchTV(req: FetchMoviesRequest)
    case searchMovies(req: SearchMovieRequest)
    case addFavouriteMovie(req: AddFavouriteRequest)
    case fetchFavouriteMovies(req: FetchFavouriteMovieRequest)
}

extension MoviesApi: TargetType {
    var baseURL: URL {
        // TODO: Másik baseurl
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
        case .searchMovies:
            return "search/movie"
        case let .fetchFavouriteMovies(req):
            return "account/\(req.accountId)/favorite/movies"
        case .addFavouriteMovie(req: let req):
            return "account/\(req.accountId)/favorite"
        case .fetchTV:
            return "discover/tv"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchGenres, .fetchTVGenres, .fetchMovies, .fetchTV, .searchMovies, .fetchFavouriteMovies:
            return .get
        case .addFavouriteMovie:
            return .post
        }
    }
    
    // TODO: Másik encoding
    var task: Task {
        switch self {
        case .fetchGenres(let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchTVGenres(let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchTV(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .searchMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchFavouriteMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .addFavouriteMovie(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case let .fetchGenres(req):
            return ["Authorization": req.accessToken]
        case let .fetchTVGenres(req):
            return ["Authorization": req.accessToken]
        case let .fetchMovies(req):
            return ["Authorization": req.accessToken]
        case let .fetchTV(req):
            return ["Authorization": req.accessToken]
        case let .searchMovies(req):
            return [
                "Authorization": req.accessToken,
                "accept": "application/json"
            ]
        case let .fetchFavouriteMovies(req):
            return ["Authorization": req.accessToken]
        case .addFavouriteMovie(req: let req):
            return ["Authorization": req.accessToken]
        }
    }
    
}
