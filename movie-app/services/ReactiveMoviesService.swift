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
import Alamofire

protocol ReactiveMoviesServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func searchMovies(req: SearchMovieRequest) -> AnyPublisher<[Movie], MovieError>
    func fetchMovies(req: FetchMoviesRequest) -> AnyPublisher<[Movie], MovieError>
    func fetchTV(req: FetchMoviesRequest) -> AnyPublisher<[Movie], MovieError>
    func fetchFavouriteMovies(req: FetchFavouriteMovieRequest, fromLocal: Bool) -> AnyPublisher<[Movie], MovieError>
    func editFavouriteMovie(req: ModifyMediaRequest) -> AnyPublisher<EditFavouriteResult, MovieError>
    func fetchMovieDetail(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError>
    func fetchMovieCredits(req: FetchMovieCreditsRequest) -> AnyPublisher<[CastMember], MovieError>
//    func addReview(req: AddReviewRequest) -> AnyPublisher<[ModifyMediaResult], MovieError>
}

class ReactiveMoviesService: ReactiveMoviesServiceProtocol {
    
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    
    @Inject
    private var store: MediaItemStoreProtocol
    
    @Inject
    private var detailStore: MediaItemDetailStoreProtocol
    
    @Inject
    private var castMemberStore: CastMemberStoreProtocol
    
    @Inject
    private var networkMonitor: NetworkMonitorProtocol
    
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
    
//    func addReview(req: AddReviewRequest) -> AnyPublisher<[ModifyMediaResult], MovieError> {
//        requestAndTransform(
//            target: MultiTarget(MoviesApi.addReview(req: req)),
//            decodeTo: ModifyMediaResponse.self,
//            transform: { ModifyMediaResult(dto: response) }
//        )
//    }
    
    func fetchFavouriteMovies(req: FetchFavouriteMovieRequest, fromLocal: Bool = false) -> AnyPublisher<[Movie], MovieError> {
            
            let serviceResponse: AnyPublisher<[Movie], MovieError> = self.requestAndTransform(
                target: MultiTarget(MoviesApi.fetchFavouriteMovies(req: req)),
                decodeTo: MoviePageResponse.self,
                transform: { $0.results.map(Movie.init(dto:)) }
            )
            .handleEvents(receiveOutput: { [weak self]mediaItems in
                self?.store.saveMediaItems(mediaItems)
            })
            .eraseToAnyPublisher()
            
            let localResponse: AnyPublisher<[Movie], MovieError> = store.mediaItems
            
            return networkMonitor.isConnected
                .flatMap { isConnected -> AnyPublisher<[Movie], MovieError> in
                    if isConnected {
                        return serviceResponse
                    } else {
                        return localResponse
                    }
                }
                .eraseToAnyPublisher()
        }
    
    func fetchMovieDetail(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError> {
        
        let serviceResponse: AnyPublisher<MediaItemDetail, MovieError> = self.requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovieDetail(req: req)),
            decodeTo: MovieDetailResponse.self,
            transform: { MediaItemDetail.init(dto: $0) }
        )
            .handleEvents(receiveOutput: { [weak self]mediaItemDetail in
                self?.detailStore.saveMediaItemDetail(mediaItemDetail)
            })
            .eraseToAnyPublisher()
        
        let localResponse: AnyPublisher<MediaItemDetail, MovieError> = detailStore.getMediaItemDetail(withId: req.mediaId)
        
        return networkMonitor.isConnected
            .flatMap { isConnected -> AnyPublisher<MediaItemDetail, MovieError> in
                if isConnected {
                    return serviceResponse
                } else {
                    return localResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchMovieCredits(req: FetchMovieCreditsRequest) -> AnyPublisher<[CastMember], MovieError> {
        
        return networkMonitor.isConnected
            .flatMap { isConnected -> AnyPublisher<[CastMember], MovieError> in
                if isConnected {
                    return self.requestAndTransform(
                        target: MultiTarget(MoviesApi.fetchMovieCredits(req: req)),
                        decodeTo: MovieCreditsResponse.self,
                        transform: { dto in
                            dto.cast.map(CastMember.init(dto:))
                        }
                    )
                    .handleEvents(receiveOutput: { [weak self]castMembers in
                        self?.castMemberStore.saveCastMembers(castMembers, forMovieId: req.mediaId)
                    })
                    .eraseToAnyPublisher()
                } else {
                    return self.castMemberStore.getCastMembers(fromMovieId: req.mediaId)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func editFavouriteMovie(req: ModifyMediaRequest) -> AnyPublisher<EditFavouriteResult, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.editFavouriteMovie(req: req)),
            decodeTo: ModifyMediaResponse.self,
            transform: { response in
                EditFavouriteResult(dto: response)
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
                            future(.failure(MovieError.mappingError(message: error.localizedDescription)))
                        }
                    case 400..<500:
                        future(.failure(MovieError.clientError))
                    case 500..<600:
                        future(.failure(MovieError.serverError))
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
                case .failure(let error):
                    if error.isNoInternetError {
                        future(.failure(MovieError.noInternetError))
                    } else {
                        future(.failure(MovieError.unexpectedError))
                    }
                }
            }
        }
        return future
            .eraseToAnyPublisher()
            
    }
}

extension MoyaError {
    var isNoInternetError: Bool {
        if case let .underlying(error, _) = self {
            // Ha AFError
            if let afError = error as? AFError {
                if let urlError = afError.underlyingError as? URLError {
                    return urlError.code == .notConnectedToInternet
                } else if let nsError = afError.underlyingError as NSError? {
                    return nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorNotConnectedToInternet
                }
            }
        }
        return false
    }
}
