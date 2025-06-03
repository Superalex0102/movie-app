//
//  GenreSectionUseCase.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 27..
//

import InjectPropertyWrapper
import Combine

protocol GenreSectionUseCase {
    var showAppearPopup: AnyPublisher<Bool, Never> { get }
    func loadGenres() -> AnyPublisher<[Genre], MovieError>
    func loadMovies(genre: Genre, number: Int) -> AnyPublisher<[Movie], MovieError>
    func loadMotdMovie(movie: Movie) -> AnyPublisher<MediaItemDetail, MovieError>
    func genresAppeared()
}

class GenreSectionUseCaseImpl: GenreSectionUseCase {
    
    @Inject
    private var repository: MovieRepository
    
    private var appearCounter = 0
    
    private var appearSubject = CurrentValueSubject<Int, Never>(0)
    
    var showAppearPopup: AnyPublisher<Bool, Never> {
        appearSubject.map { counter in
            counter == 3
        }
        .eraseToAnyPublisher()
    }
    
    func loadGenres() -> AnyPublisher<[Genre], MovieError> {
        let request = FetchGenreRequest()
        
        let genres = Environments.name == .tv ?
        self.repository.fetchTVGenres(req: request) :
        self.repository.fetchGenres(req: request)
        
        return genres
            .handleEvents(receiveOutput: { genres in
                print("Custom action before receive: genres count = \(genres.count)")
            })
            .eraseToAnyPublisher()
    }
    
    func loadMovies(genre: Genre, number: Int) -> AnyPublisher<[Movie], MovieError> {
        let request = FetchMoviesRequest(genreId: genre.id, includeAdult: true, page: 1)
        
        let movies = self.repository.fetchMovies(req: request)
        
        return movies
            .map { movies in
                Array(movies.movies.prefix(number))
            }
            .handleEvents(receiveOutput: { movies in
                print("Custom action before receive: movies count = \(movies.count)")
            })
            .eraseToAnyPublisher()
    }
    
    func loadMotdMovie(movie: Movie) -> AnyPublisher<MediaItemDetail, MovieError> {
        let request = FetchDetailRequest(mediaId: movie.id)
        let detailMediaItem = self.repository.fetchMovieDetail(req: request)
        
        return detailMediaItem
    }
    
    func genresAppeared() {
        appearCounter += 1
        appearSubject.send(appearCounter)
    }
}
