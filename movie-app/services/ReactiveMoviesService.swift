//
//  ReactiveMoviesService.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 09..
//

import Foundation
import Moya
import InjectPropertyWrapper
import Combine

protocol ReactiveMoviesServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func searchMovies(req: SearchMovieRequest) -> AnyPublisher<[Movie], MovieError>
    func fetchMovies(req: FetchMoviesRequest) -> AnyPublisher<[Movie], MovieError>
    func fetchTV(req: FetchMoviesRequest) -> AnyPublisher<[Movie], MovieError>
    func fetchFavouriteMovies(req: FetchFavouriteMovieRequest) -> AnyPublisher<[Movie], MovieError>
    func addFavoriteMovie(req: AddFavouriteRequest) -> AnyPublisher<AddFavoriteResponse, MovieError>
}

class ReactiveMoviesService: ReactiveMoviesServiceProtocol {
    
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTVGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func searchMovies(req: SearchMovieRequest) -> AnyPublisher<[Movie], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.searchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(Movie.init(dto:)) }
        )
    }
    
    func fetchMovies(req: FetchMoviesRequest) -> AnyPublisher<[Movie], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(Movie.init(dto:)) }
        )
    }
    
    func fetchTV(req: FetchMoviesRequest) -> AnyPublisher<[Movie], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTV(req: req)),
            decodeTo: TVPageResponse.self,
            transform: { $0.results.map(Movie.init(dto:)) }
        )
    }
    
    func fetchFavouriteMovies(req: FetchFavouriteMovieRequest) -> AnyPublisher<[Movie], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchFavouriteMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(Movie.init(dto:)) }
        )
    }
    
    //TODO: Reafctorn and create a domain model to AddFavoriteResponse
    func addFavoriteMovie(req: AddFavouriteRequest) -> AnyPublisher<AddFavoriteResponse, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.addFavouriteMovie(req: req)),
            decodeTo: AddFavoriteResponse.self,
            transform: { response in
                response
            }
        )
    }
    
    private func requestAndTransform<ResponseType: Decodable, Output>(
        target: MultiTarget,
        decodeTo: ResponseType.Type,
        transform: @escaping (ResponseType) -> Output
    ) -> AnyPublisher<Output, MovieError> {
        let future = Future<Output, MovieError> { future in
            self.moya.request(target) { result in
                switch result {
                case .success(let response):
                    switch response.statusCode {
                    case 200..<300:
                        do {
                            let decoded = try JSONDecoder().decode(decodeTo, from: response.data)
                            let output = transform(decoded)
                            future(.success(output))
                        } catch {
                            future(.failure(MovieError.unexpectedError))
                        }
                    case 400..<500:
                        future(.failure(MovieError.clientError))
                    default:
                        if let apiError = try? JSONDecoder().decode(MovieAPIErrorResponse.self, from: response.data) {
                            if apiError.statusCode == 7 {
                                future(.failure(MovieError.invalidApiKeyError(message: apiError.statusMessage)))
                            } else {
                                future(.failure(MovieError.unexpectedError))
                            }
                        } else {
                            future(.failure(MovieError.unexpectedError))
                        }
                    }
                case .failure:
                    future(.failure(MovieError.unexpectedError))
                }
            }
        }
        return future
            .eraseToAnyPublisher()
            
    }
}
