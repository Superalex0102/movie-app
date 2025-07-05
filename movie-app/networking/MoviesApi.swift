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
    case editFavouriteMovie(req: EditFavouriteRequest)
    case fetchFavouriteMovies(req: FetchFavouriteMovieRequest)
    case fetchMovieDetail(req: FetchDetailRequest)
    case fetchMovieCredits(req: FetchMovieCreditsRequest)
    case fetchCastMemberDetail(req: FetchCastMemberDetailRequest)
    case fetchCompanyDetail(req: FetchCastMemberDetailRequest)
    case fetchSimiliarMovie(req: FetchSimilarMovieRequest)
    case addReview(req: AddReviewRequest)
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
        case .editFavouriteMovie(req: let req):
            return "account/\(req.accountId)/favorite"
        case .fetchTV:
            return "discover/tv"
        case .fetchMovieDetail(req: let req):
            return "movie/\(req.mediaId)"
        case .fetchMovieCredits(req: let req):
            return "movie/\(req.mediaId)/credits"
        case .fetchCastMemberDetail(req: let req):
            return "person/\(req.castMemberId)"
        case .fetchCompanyDetail(req: let req):
            return "company/\(req.castMemberId)"
        case .fetchSimiliarMovie(req: let req):
            return "movie/\(req.mediaItemId)/similar"
        case .addReview(req: let req):
            return "movie/\(req.mediaId)/rating"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchGenres, .fetchTVGenres, .fetchMovies, .fetchTV, .searchMovies, .fetchFavouriteMovies, . fetchMovieDetail, .fetchMovieCredits, .fetchCastMemberDetail, .fetchCompanyDetail, .fetchSimiliarMovie:
            return .get
        case .editFavouriteMovie, .addReview:
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
        case .editFavouriteMovie(req: let req):
            let request = EditFavouriteBodyRequest(movieId: req.movieId, isFavourite: req.isFavourite)
                return .requestJSONEncodable(request)
        case .fetchMovieDetail(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchMovieCredits(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchCastMemberDetail(let req):
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case .fetchCompanyDetail(let req):
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case let .fetchSimiliarMovie(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .addReview(req: let req):
            let request = AddReviewBodyRequest(mediaId: req.mediaId, rating: req.rating)
                return .requestJSONEncodable(request)
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
        case .editFavouriteMovie(req: let req):
            return [
                "Authorization": req.accessToken,
                "accept": "application/json"
            ]
        case .fetchMovieDetail(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchMovieCredits(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchCastMemberDetail(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchCompanyDetail(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchSimiliarMovie(req: let req):
            return ["Authorization": req.accessToken]
        case .addReview(req: let req):
            return [
                "Authorization": req.accessToken,
                "accept": "application/json"
            ]
        }
    }
    
}
